

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project/widget/common_button_mixin.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import '../../utils/ChunkedDownloader.dart';
import '../../utils/ResumableDownloader.dart';
import '../../utils/ResumableUpload.dart';
import '../example/refresh/RefreshLoadMoreExample.dart';
import '../example/refresh/RefreshLoadMoreExample1.dart';
import '../example/refresh/RefreshLoadMoreExample2.dart';


// import 'splash_logic.dart';
// import 'splash_state.dart';

///用于表示功能列表页


class FunctionListPage extends StatefulWidget {
  @override
  _FunctionListPageState createState() => _FunctionListPageState();
}

class _FunctionListPageState extends State<FunctionListPage> with CommonButtonMixin{
  // final SplashLogic logic = Get.put(SplashLogic());
  // final SplashState state = Get.find<SplashLogic>().state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // logic.checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("功能列表页"),
      ),
      body: SingleChildScrollView(
        child:
        Container(
          child: Column(
            children: [
              ///用于表示选择文件并上传
              // Text("data"),

              Padding(padding: EdgeInsets.only(top: 20)),

              commonButton("选择文件", Color(0xff2FA7FE), (){


                pickFiles();
              }),
              Padding(padding: EdgeInsets.only(top: 20)),

              commonButton("分块上传", Color(0xff2FA7FE), (){
                uploadFileByChunk();
              }),

              Padding(padding: EdgeInsets.only(top: 20)),

              ///用于表示分块下载
              commonButton("分块下载", Color(0xff2FA7FE), (){
                _startDownload();
              }),

              Padding(padding: EdgeInsets.only(top: 20)),


              ///用于表示下拉刷新
              commonButton("下拉刷新", Color(0xff2FA7FE), (){
                Get.to(() => RefreshLoadMoreExample());

              }),
              Padding(padding: EdgeInsets.only(top: 20)),

              commonButton("下拉刷新1", Color(0xff2FA7FE), (){
                Get.to(() => RefreshLoadMoreExample1());

              }),
              Padding(padding: EdgeInsets.only(top: 20)),

              commonButton("下拉刷新2", Color(0xff2FA7FE), (){
                Get.to(() => RefreshLoadMoreExample2());

              }),



            ],
          ),

        )

      ),
    );
  }

  @override
  void dispose() {
    // Get.delete<SplashLogic>();
    super.dispose();
  }

  ///用于文件选择
  FileType pickingType = FileType.any;
  String? _extension;
  final _dialogTitleController = TextEditingController();
  final _initialDirectoryController = TextEditingController();
  bool _lockParentWindow = false;

  ///用于表示选择到的文件
  late File selectedFile;
  ///用于选择文件并发送
  void pickFiles() async {
    _resetState();
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: pickingType,
          allowMultiple: false,
          onFileLoading: (FilePickerStatus status) => print(status),
          allowedExtensions: (_extension?.isNotEmpty ?? false)
              ? _extension?.replaceAll(' ', '').split(',')
              : null,
          dialogTitle: _dialogTitleController.text,
          initialDirectory: _initialDirectoryController.text,
          lockParentWindow: _lockParentWindow,
          withData: true);

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        // toast("文件加载中");

        selectedFile=files.first;
        ///用于表示读取到的文件
        // Uint8List fileBytes = result.files.first.bytes!;
        //
        // int downloadFileSize = fileBytes.length;

      } else {
        toast("取消文件选择");
      }
    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    } catch (e) {
      print(e.toString());
    }

    // setState(() {
    //   loading = false;
    // });

    if (!mounted) return;
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
  }



  ///用于表示分块上传
  uploadFileByChunk(){
    ResumableUpload resumableUpload=ResumableUpload( file: selectedFile);
    resumableUpload.upload();
  }

  ///用于表示分块下载
  // downloadFileByChunk() async {
  //   ResumableDownloader downloader = ResumableDownloader(
  //     fileUrl: 'http://localhost:8080/download?bucketName=your-bucket-name&objectName=your-object-name',
  //     savePath: '/path/to/save/file.apk',
  //   );
  //
  //   await downloader.download();
  // }

  ///用于表示分块下载
  void _startDownload() async {
    setState(() {
      // _isDownloading = true;
    });

    final downloader = ChunkedDownloader(
      // url: 'http://localhost:8080/download?bucket=mybucket&object=myfile.txt',
      url: 'http://192.168.19.123:8002/download/chunk?bucket=big-file&object=app-ble-photovoltaic-tool-24071202.apk',
      filePath: '/path/to/save/myfile.apk',
    );

    await downloader.download();

    // setState(() {
    //   _isDownloading = false;
    //   _progress = 1.0;
    // });
  }


  ///用于表示显示提示
  void toast(String info) {
    Fluttertoast.showToast(
        msg: info,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

}
