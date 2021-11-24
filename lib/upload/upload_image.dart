import 'package:flutter/material.dart';

class ImageAvatar extends StatelessWidget {
  const ImageAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipOval(
        child: CachedNetworkImage(
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.person),
          imageUrl: userInfo.photo ?? "",
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class UploadImage {
  void uploadImage(BuildContext context, String tenantId, String uid) async {
    // final pickedFile =
    //     await ImagePicker().pickImage(source: ImageSource.gallery);
    final pickedFile = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);

    // ignore: unused_local_variable
    // var file = (pickedFile!.path); // <-- an important unused

    final destination = 'uploads/$tenantId/$uid/profile_image';

    // firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
    //     .ref(destination)
    //     .putData(await pickedFile.readAsBytes());
    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref(destination)
        .putData(pickedFile!.files.first.bytes!);

    try {
      firebase_storage.TaskSnapshot snapshot = await task;
      String url = await snapshot.ref.getDownloadURL();
      UserModel().updatePhoto(tenantId, uid, url);
      topSnackbar(context, 'Profiel foto is gewijzigd');
    } on FirebaseException catch (e) {
      topSnackbar(context, 'Upload error: ${e.message}');
      if (e.code == 'permission-denied') {
        topSnackbar(context,
            'Gebruiker heeft geen permissie voor het oploaden van een foto');
      }
    }
  }

  void topSnackbar(BuildContext context, String content) {
    showFlash(
      context: context,
      duration: const Duration(seconds: 4),
      builder: (context, controller) {
        return Flash(
          controller: controller,
          behavior: FlashBehavior.floating,
          position: FlashPosition.top,
          boxShadows: kElevationToShadow[4],
          backgroundColor: Colors.grey[50],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            content:
                Text(content, style: Theme.of(context).textTheme.headline5),
          ),
        );
      },
    );
  }
}
