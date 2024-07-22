// import 'package:ecoreporte/domain/entities/info.dart';
// import 'package:ecoreporte/data/repositories/info_repository_impl.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../utils/secure_storage.dart';

// class UserInfoWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final secureStorage = SecureStorage();
//     final infoRepository = Provider.of<InfoRepositoryImpl>(context);

//     return FutureBuilder<Info>(
//       future: _loadContent(infoRepository, secureStorage),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else if (!snapshot.hasData) {
//           return Center(child: Text('No hay contenido disponible'));
//         } else {
//           final content = snapshot.data!;
//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(content.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 8),
//                 Text(content.description),
//                 SizedBox(height: 16),
//                 Image.network(content.imageUrl),
//                 SizedBox(height: 16),
//                 Text(content.content),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }

//   Future<Info> _loadContent(InfoRepositoryImpl repository, SecureStorage secureStorage) async {
//     final token = await secureStorage.getToken();
//     if (token != null) {
//       return await repository.getContentByCode(token);
//     } else {
//       throw Exception('Token no disponible');
//     }
//   }
// }