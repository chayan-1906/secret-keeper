import 'package:diary_app/framework/widgets/skywa_appbar.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
            imageProvider: NetworkImage(widget.imageUrl),
            initialScale: PhotoViewComputedScale.contained,
            filterQuality: FilterQuality.high,
          );
        },
        itemCount: 1,
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              strokeWidth: 8.0,
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
        backgroundDecoration: BoxDecoration(color: Colors.transparent),
      ),
    );
  }
}
