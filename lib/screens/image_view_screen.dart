import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../generated/assets.dart';

class ImageViewScreen extends StatefulWidget {
  // final String name;
  final String imageUrl;
  const ImageViewScreen({
    Key key,
    // @required this.name,
    @required this.imageUrl,
  }) : super(key: key);

  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<ImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SkywaAppBar(appbarText: widget.name),
      ),*/
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            minScale: PhotoViewComputedScale.contained,
            imageProvider: CachedNetworkImageProvider(widget.imageUrl),
            initialScale: PhotoViewComputedScale.contained,
            filterQuality: FilterQuality.high,
          );
        },
        itemCount: 1,
        loadingBuilder: (context, event) => Center(
          /*child: Container(
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              strokeWidth: 2.0,
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),*/
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child: Image.asset(
                  Assets.imagesImagePlaceholder,
                  height: Device.screenHeight / 2,
                  width: Device.screenWidth / 2,
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                height: Device.screenHeight / 2,
                width: Device.screenWidth / 2,
                child: LinearProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Colors.grey.withOpacity(0.5)),
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        backgroundDecoration: BoxDecoration(color: Colors.transparent),
      ),
    );
  }
}
