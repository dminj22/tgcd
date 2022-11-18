import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarImageHolder extends StatelessWidget {
  final url;
  final fit;

  const AvatarImageHolder({Key? key, this.url, this.fit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: "$url",
      imageBuilder: (context, imageProvider) => Container(
        margin: EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Center(child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}


showSnackBar(context, msg){
  var snackBar = SnackBar(
    content: Text('$msg'),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String getTimeDifferenceFromNow(DateTime d) {
  Duration difference = DateTime.now().difference(d);
  if (difference.inSeconds < 5) {
    return "Just now";
  } else if (difference.inMinutes < 1) {
    return "${difference.inSeconds}s ago";
  } else if (difference.inHours < 1) {
    return "${difference.inMinutes}m ago";
  } else if (difference.inHours < 24) {
    return "${difference.inHours}h ago";
  } else {
    return "${difference.inDays}d ago";
  }
}
