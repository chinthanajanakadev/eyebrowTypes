///File download from FlutterViz- Drag and drop a tools. For more details visit https://flutterviz.io/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:easy_image_viewer/easy_image_viewer.dart';
// import 'dart:math';
import 'package:photo_view/photo_view.dart';
import 'dart:io';

import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:url_launcher/url_launcher.dart';
//ML Kit
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
//
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eyebrow Types',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.pink,
          backgroundColor: Colors.black,
          scaffoldBackgroundColor: Colors.black),
      home: const MyHomePage(title: 'A.Eye'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // testing
  // late String InterstitialAdID = "ca-app-pub-3940256099942544/1033173712";
  //production
  late String InterstitialAdID = "ca-app-pub-4977317413391095/1070508049";

  final BannerAd myBanner = BannerAd(
    //testing
    // adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    //production
    adUnitId: 'ca-app-pub-4977317413391095/3515225754',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) => {print('Ad loaded.')},
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
    ),
  );

  late AdWidget adWidget;

  List<ChartData> chartDataSource = [
    // Bind data source
    ChartData("", 0.0),
    ChartData('', 0.0),
    ChartData("", 0.0),
    ChartData("", 0.0),
    ChartData("", 0.0)
  ];

  // var advisible = true;

  ImageProvider imageSelected = const AssetImage("assets/eye.jpg");
  // NetworkImage("https://picsum.photos/250?image=9");

  late bool _fileSelected = false;

  late File file;

  late ImagePicker picker;
  late ImageCropper imageCropper;

  late String label = "";

  late String confidence = "";

  List? recognitions;

  late ImageLabeler imageLabeler;



  @override
  void initState() {
    super.initState();
    // Load ads.
    myBanner.load();
    adWidget = AdWidget(ad: myBanner);
    // _loadAI();
    loadMLmodel();
    picker = ImagePicker();
    imageCropper = ImageCropper();
    _emptyCache();
    loadInterstitialAd();
  }

  void _gotoDetailsPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text('Analyzed Image'),
          ),
          body: Center(
            child: Hero(
              tag: 'hero-rectangle',
              child: PhotoView(
                // imageProvider: imageSelected,
                imageProvider: imageSelected,
              ),
            ),
          ),
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eyebrow Type"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.camera_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
              _openCamera();
              // _updateChartData();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.image_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
              _openImagePicker();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.share_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
              // shareImage();
              showInterstitialAd();
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: WidgetsToImage(
              controller: controller,
              child: Card(
                color: Colors.black,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.zero,
                  shrinkWrap: false,
                  physics: const ScrollPhysics(),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Card(
                            margin: EdgeInsets.all(4.0),
                            color: Colors.black,
                            // shadowColor: Color(0xffcc00ff),
                            // elevation: 5,
                            shape: const RoundedRectangleBorder(
                                // borderRadius: BorderRadius.circular(4.0),
                                // side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
                                ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Text(
                                  "$label $confidence%",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 30,
                                    color: Colors.pink.shade50,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Card(
                        //   margin: EdgeInsets.all(4.0),
                        //   color: Colors.black,
                        //   // shadowColor: Color(0xffff0000),
                        //   // elevation: 5,
                        //   shape: const RoundedRectangleBorder(
                        //       // borderRadius: BorderRadius.circular(4.0),
                        //       // side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
                        //       ),
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisSize: MainAxisSize.max,
                        //     children: [
                        //
                        //       Text(
                        //         confidence + "%",
                        //         textAlign: TextAlign.start,
                        //         overflow: TextOverflow.clip,
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.w400,
                        //           fontStyle: FontStyle.normal,
                        //           fontSize: 30,
                        //           color: Colors.pink.shade50,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                    Card(
                      // margin: EdgeInsets.all(7.0),

                      color: Colors.black,
                      // shadowColor: Colors.pink.shade400,
                      // elevation: 10,
                      shape: const RoundedRectangleBorder(
                          // borderRadius: BorderRadius.circular(20.0),
                          // side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
                          ),
                      child: Container(
                        padding: EdgeInsets.only(right: 10),
                        height: 150,
                        child: SfCartesianChart(
                          plotAreaBorderWidth: 0,
                          primaryXAxis: CategoryAxis(
                            majorGridLines: MajorGridLines(width: 0),
                            majorTickLines: MajorTickLines(size: 0),
                            axisLine: AxisLine(width: 0, color: Colors.pink),
                            labelStyle: TextStyle(
                                color: Colors.pink.shade50, fontSize: 16),
                          ),
                          primaryYAxis: NumericAxis(
                            majorGridLines: MajorGridLines(width: 0),
                            majorTickLines: MajorTickLines(size: 0),
                            axisLine:
                                AxisLine(width: 0, color: Colors.pink.shade50),
                            maximum: 100,
                            labelStyle: TextStyle(
                                color: Colors.pink.shade50, fontSize: 16),
                          ),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          palette: <Color>[
                            Colors.pink.shade500,
                            Colors.orange,
                            Colors.brown
                          ],
                          series: <ChartSeries>[
                            // Renders bar chart
                            BarSeries<ChartData, String>(
                                dataSource: chartDataSource,
                                name: "Confidence %",
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                // width: 0.2,
                                // spacing: ,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y)
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(4.0),
                      color: Colors.black,
                      // shadowColor: Color(0xff000000),
                      // elevation: 5,
                      shape: const RoundedRectangleBorder(
                          // borderRadius: BorderRadius.circular(4.0),
                          // side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
                          ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          ///***If you have exported images you must have to copy those images in assets/images directory.

                          Hero(
                            tag: 'hero-rectangle',
                            transitionOnUserGestures: true,
                            child: GestureDetector(
                              onTap: () =>
                                  _gotoDetailsPage(context), // Image tapped
                              child: _fileSelected == true
                                  ? Image.file(file)
                                  : Image(
                                      image: imageSelected,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fitWidth,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ),

          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [

              Container(
                alignment: Alignment.center,
                width: myBanner.size.width.toDouble(),
                height: myBanner.size.height.toDouble(),
                child: adWidget,
              ),

            ],
          ),
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        backgroundColor: Colors.black,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),

          children: [
            Container(
              height: 150,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.pink,
                  Colors.purple,
                ],
              )),
              child: const Center(
                child: Text(
                  'Eyebrow Type',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!await launchUrl(Uri.parse(
                    'https://simpleappcreator.blogspot.com/p/privacy-policy-eyebrow-type_16.html'))) {
                  print("can not open url");
                }
              },
              child: const Text('Privacy Policy'),
            ),

          ],
        ),
      ),
    );
  }

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  // Random _rnd = Random();

  // String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
  //     length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  //for testing chart
  // void _updateChartData() {
  //   chartDataSource.clear();
  //
  //   // chartDataSource.add(ChartData("sdfsdf", 40.0));
  //   // chartDataSource.add(ChartData("Lesdfsdfgs", 10.0));
  //   // chartDataSource.add(ChartData("Lesdggffsdfgs", 58.0));
  //   for (var i = 0; i < 5; i++) {
  //     chartDataSource
  //         .add(ChartData(getRandomString(10), Random().nextDouble() * 100));
  //   }
  //   setState(() {});
  // }

  // void _setVisible() {
  //   setState(() {
  //     advisible = true;
  //   });
  // }

  Future<String> _getModel(String assetPath) async {
    if (Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  loadMLmodel() async {
    final modelPath = await _getModel('assets/model.tflite');
    final options = LocalLabelerOptions(modelPath: modelPath, confidenceThreshold: 0.01);
    imageLabeler = ImageLabeler(options: options);
    String initImagePath = await _getImageFileFromAssets("eye.jpg");
    _runImageClassificationML(initImagePath);
  }

  // Future<void> _loadAI() async {
  //   //  load AI
  //   String? res = await Tflite.loadModel(
  //       model: "assets/model.tflite",
  //       labels: "assets/labels.txt",
  //       numThreads: 4, // defaults to 1
  //       isAsset:
  //           true, // defaults to true, set to false to load resources outside assets
  //       useGpuDelegate:
  //           false // defaults to false, set to true to use GPU delegate
  //       );
  //   String initImagePath = await _getImageFileFromAssets("eye.jpg");
  //   _runImageClassification(initImagePath);
  // }

  Future<String> _getImageFileFromAssets(String path) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filePath = "$tempPath/$path";
    File file = File(filePath);

    if (file.existsSync()) {
      return file.path;
    } else {
      final byteData = await rootBundle.load('assets/$path');
      final buffer = byteData.buffer;
      await file.create(recursive: true);
      await file.writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      return file.path;
    }
  }

  WidgetsToImageController controller = WidgetsToImageController();

  shareImage() async {
    final bytes = await controller.capture();
    // var widgetImage = Image.memory(bytes!);
    // widgetImage.
//share text
//     ShareExtend.share(
//         "share text", "text");
    //share image
    Uint8List? imageInUnit8List = bytes; // store unit8List image here ;
    final tempDir = await getTemporaryDirectory();
    File tempFile = await File('${tempDir.path}/image.png').create();
    tempFile.writeAsBytesSync(imageInUnit8List!);

    // ShareExtend.share(tempFile.path, "image");
    Share.shareXFiles([XFile(tempFile.path)], text: "Eyebrow type - Results");
    // try {
    //   await file.delete();
    // } catch (e) {
    //   print(e);
    // }
  }

  InterstitialAd? _interstitialAd;

  void loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: InterstitialAdID,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (error) {
            print('Interstitial ad failed to load: $error');
          },
        ));
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          shareImage();
          _interstitialAd = null;
          // loadInterstitialAd();
        },
      );
      _interstitialAd!.show();
    } else {
      shareImage();
      print('Interstitial ad not ready to show.');
    }
  }

  // Future<void> _runImageClassification(String filePath) async {
  //   recognitions = await Tflite.runModelOnImage(
  //       path: filePath, // required
  //       imageMean: 0.0, // defaults to 117.0
  //       imageStd: 255.0, // defaults to 1.0
  //       numResults: 5, // defaults to 5
  //       threshold: 0.00001, // defaults to 0.1
  //       asynch: true // defaults to true
  //       );
  //   print(recognitions![0]["confidence"]);
  //   setState(() {
  //     label = recognitions![0]["label"];
  //     confidence = (recognitions![0]["confidence"] * 100).toStringAsFixed(0);
  //   });
  //
  //   chartDataSource.clear();
  //
  //   recognitions?.forEach((element) {
  //     // double.parse((element["confidence"])*100.toStringAsFixed(2));
  //     chartDataSource
  //         .add(ChartData(element["label"], (element["confidence"]) * 100));
  //   });
  // }

  Future<void> _runImageClassificationML(String filePath) async {
    // recognitions = await Tflite.runModelOnImage(
    //     path: filePath, // required
    //     imageMean: 0.0, // defaults to 117.0
    //     imageStd: 255.0, // defaults to 1.0
    //     numResults: 5, // defaults to 5
    //     threshold: 0.00001, // defaults to 0.1
    //     asynch: true // defaults to true
    // );
    final inputImage = InputImage.fromFilePath(filePath);
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

    // for (ImageLabel label in labels) {
    //   final String text = label.label;
    //   final int index = label.index;
    //   final double confidence = label.confidence;
    // }
    // print(recognitions![0]["confidence"]);
    setState(() {
      label = labels[0].label;
      confidence = (labels[0].confidence * 100).toStringAsFixed(0);
    });

    chartDataSource.clear();

    // recognitions?.forEach((element) {
    //   // double.parse((element["confidence"])*100.toStringAsFixed(2));
    //   chartDataSource.add(ChartData(element["label"], (element["confidence"]) * 100));
    // });

    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      chartDataSource.add(ChartData(label.label, (label.confidence) * 100));
    }
  }

  Future<void> _openImagePicker() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    print(image!.path);
    // opening cropper
    CroppedFile? croppedFile = await imageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop image to select Eyebrow',
            toolbarColor: Colors.pink,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        // WebUiSettings(
        //   context: context,
        // ),
      ],
    );
    //

    setState(() {
      _fileSelected = true;
      file = File(croppedFile!.path);
      imageSelected = FileImage(file);
    });

    // _runImageClassification(file.path);
    _runImageClassificationML(file.path);
  }

  Future<void> _openCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    print(image!.path);
    // opening cropper
    CroppedFile? croppedFile = await imageCropper.cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop image to select Eyebrow',
            toolbarColor: Colors.pink,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        // WebUiSettings(
        //   context: context,
        // ),
      ],
    );
    //

    setState(() {
      _fileSelected = true;
      file = File(croppedFile!.path);
      imageSelected = FileImage(file);
    });

    // _runImageClassification(file.path);
    _runImageClassificationML(file.path);
  }

  Future<void> _emptyCache() async {
    await DefaultCacheManager().emptyCache();
  }


}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
