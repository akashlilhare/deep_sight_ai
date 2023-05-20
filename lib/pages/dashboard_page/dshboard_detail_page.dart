import 'package:deep_sight_ai_labs/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../model/dashboard_model.dart';
import '../../provider/dashboard_detail_provider.dart';
import '../../services/video_player.dart';

class DashboardDetailPage extends StatefulWidget {
  final AlertData dashboardProvider;
  final Map<String, dynamic> jsonData;
  final int index;

  const DashboardDetailPage(
      {Key? key,
      required this.dashboardProvider,
      required this.jsonData,
      required this.index})
      : super(key: key);

  @override
  State<DashboardDetailPage> createState() => _DashboardDetailPageState();
}

class _DashboardDetailPageState extends State<DashboardDetailPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> dataItem = widget.jsonData["data"]["alert_data"][widget.index];

    buildDetail(
        {required String title, required String subtitle, Color? color}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                subtitle,
                style: TextStyle(
                    fontSize: 16,
                    color: color ??
                        Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(.7),
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      );
    }

    Widget getDetails() {
      List<List<String>> arrList = [];
      dataItem.forEach((key, value) {
        arrList.add([key.toString(), value.toString()]);
      });

      return Column(
          children: arrList
              .map((e) => buildDetail(title: e[0], subtitle: e[1]))
              .toList());
    }

    String shareString() {
      List<List<String>> arrList = [];
      dataItem.forEach((key, value) {
        arrList.add([key.toString(), value.toString()]);
      });

      String parsed = "";

      for (int i = 0; i < arrList.length; i++) {
        parsed += "${arrList[i][0]} : ${arrList[i][1]}\n";
      }

      return parsed;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Share.share(shareString());
              },
              icon: Icon(Icons.share_outlined)),
          SizedBox(
            width: 8,
          )
        ],
        title: Text(
            "${widget.dashboardProvider.featureType} #${widget.dashboardProvider.id}"),
      ),
      body: Consumer<DashboardDetailProvider>(builder: (context, provider, _) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: Align(
                  child: ToggleSwitch(
                    inactiveBgColor: Colors.blue.withOpacity(.2),
                    initialLabelIndex: provider.isImage ? 0 : 1,
                    totalSwitches: 2,
                    labels: ['Image', 'Video'],
                    onToggle: (index) {
                      print(index);
                      provider.switchMedia(idx: index ?? 0);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () {
                  if (!provider.isImage) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (builder) {
                      return VideoPlayerHelper(
                        path: widget.dashboardProvider.videoPath ?? "",
                      );
                    }));
                  }
                },
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.passthrough,
                  children: [
                    Container(
                      height: 220,
                        color: Colors.black,
                        child: Opacity(
                            opacity: provider.isImage ? 1 : .5,
                            child:
                            FadeInImage.assetNetwork(

                              placeholder: 'assets/place_holder.gif',
                              image:  widget.dashboardProvider.imagePath
                            ),

                           )),
                    if (!provider.isImage)
                      Center(
                        child: Icon(
                          size: 60,
                          Icons.play_circle_fill_outlined,
                          color: Colors.white,
                        ),
                      )
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (builder) {
                            return AlertDialog(
                              title: Row(
                                children: const [
                                  Spacer(),
                                  CircularProgressIndicator(),
                                  SizedBox(
                                    width: 22,
                                  ),
                                  Text("Downloading..."),
                                  Spacer(),
                                ],
                              ),
                            );
                          });
                      await FileDownloader.downloadFile(
                          url: provider.isImage
                              ? widget.dashboardProvider.imagePath
                              : widget.dashboardProvider.videoPath ?? "",
                          onDownloadCompleted: (String path) {
                            try {
                              OpenFile.open(path);
                            } catch (e) {
                              Constant()
                                  .getToast(title: "Something went wrong");
                            }
                          },
                          onDownloadError: (String error) {
                            Constant().getToast(title: "Something went wrong");
                          });

                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text(
                        "Download ${provider.isImage ? "Image" : "Video"}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
                  SizedBox(
                    width: 2,
                  ),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      Share.share(
                        provider.isImage
                            ? widget.dashboardProvider.imagePath
                            : widget.dashboardProvider.videoPath ?? "",
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text(
                        "Share ${provider.isImage ? "Image" : "Video"}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              getDetails(),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        );
      }),
    );
  }
}
