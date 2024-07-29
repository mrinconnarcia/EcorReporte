import 'package:ecoreporte/presentation/widgets/CreateCommunityModal.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authentication_bloc.dart';
import '../bloc/authentication_event.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../utils/secure_storage.dart';
import '../widgets/SharedBottomNavigationBar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserRepositoryImpl userRepository = UserRepositoryImpl();
  final SecureStorage secureStorage = SecureStorage();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController roleController;
  late TextEditingController genderController;
  late TextEditingController codeController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    roleController = TextEditingController();
    genderController = TextEditingController();
    codeController = TextEditingController();
    _loadUserData();
  }

  void _loadUserData() async {
    final userData = await secureStorage.getUserData();
    if (userData == null) {
      print('No user data found in secure storage');
      return;
    }

    String? email = userData['email'];
    if (email == null) {
      print('No email found in user data');
      return;
    }

    try {
      final userDataFromApi = await userRepository.getUserDataByEmail(email);
      print('Datos del usuario cargados: $userDataFromApi'); // Debugging
      setState(() {
        nameController.text = userDataFromApi['name'] ?? '';
        lastNameController.text = userDataFromApi['lastName'] ?? '';
        emailController.text = userDataFromApi['email'] ?? '';
        phoneController.text = userDataFromApi['phone'] ?? '';
        roleController.text = userDataFromApi['role'] ?? '';
        genderController.text = userDataFromApi['gender'] ?? '';
        codeController.text = userDataFromApi['code'] ?? '';
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>?>(
        future: userRepository.getUserDataByEmail(emailController.text),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('No se encontraron datos del usuario'));
          } else {
            final userData = snapshot.data!;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    color: Color(0xFF9DE976),
                    padding: EdgeInsets.fromLTRB(16, 40, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset('assets/eco_reporte_logo.png',
                                height: 40),
                            SizedBox(width: 8),
                            Text(
                              'EcoReporte',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.exit_to_app),
                          onPressed: () {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.bottomSlide,
                              title: 'Cerrar Sesión',
                              desc: '¿Está seguro que desea cerrar sesión?',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                await secureStorage.deleteUserInfo();
                                authenticationBloc.add(LoggedOut());
                                Navigator.of(context).pushReplacementNamed('/');
                              },
                              btnCancelText: 'Cancelar',
                              btnOkText: 'Sí, cerrar sesión',
                            )..show();
                          },
                          tooltip: 'Cerrar sesión',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: ListView(
                        children: [
                          Text('Hola!',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          Text('Bienvenido, ${userData['name']} ',
                              style: TextStyle(fontSize: 18)),
                          Text(
                            'Tu codigo de comunidad es: ${userData['code']}',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(height: 20),
                          _buildEditableInfoRow('Nombre', nameController),
                          _buildEditableInfoRow(
                              'Apellidos', lastNameController),
                          _buildEditableInfoRow('Correo', emailController,
                              readOnly: true),
                          _buildEditableInfoRow('Teléfono', phoneController),
                          _buildEditableInfoRow('Rol', roleController,
                              readOnly: true),
                          _buildEditableInfoRow('Género', genderController),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final updatedUserData = {
                                  'name': nameController.text,
                                  'lastName': lastNameController.text,
                                  'email': emailController.text,
                                  'phone': phoneController.text,
                                  'role': roleController.text,
                                  'gender': genderController.text,
                                };

                                bool success = await userRepository
                                    .updateUser(updatedUserData);
                                if (success) {
                                  // Guardar los datos actualizados en el almacenamiento seguro
                                  await secureStorage
                                      .saveUserData(updatedUserData);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Cuenta actualizada exitosamente')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Error al actualizar la cuenta')),
                                  );
                                }
                              }
                            },
                            child: Text('Actualizar cuenta'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF9DE976),
                                foregroundColor: Colors.black),
                          ),
                          SizedBox(height: 10),
                          if (userData['role'] == 'admin')
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => CreateCommunityModal(
                                    onCommunityCreated: _loadUserData,
                                  ),
                                );
                              },
                              child: Text('Crear Comunidad'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                final confirmDelete = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Eliminar cuenta'),
                                    content: Text(
                                        '¿Estás seguro de que deseas eliminar tu cuenta?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Text('Eliminar'),
                                        style: TextButton.styleFrom(
                                            foregroundColor: Colors.red),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmDelete == true) {
                                  bool success = await userRepository
                                      .deleteUser(emailController.text);
                                  if (success == true) {
                                    await secureStorage.deleteUserInfo();
                                    authenticationBloc.add(LoggedOut());
                                    Navigator.of(context)
                                        .pushReplacementNamed('/');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Error al eliminar la cuenta')),
                                    );
                                  }
                                }
                              } catch (error) {
                                print('Error al eliminar la cuenta: $error');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Ocurrió un error. Por favor, intenta de nuevo.')),
                                );
                              }
                            },
                            child: Text('Eliminar cuenta'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: SharedBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home-app');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/info-app');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/add-report');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/history');
          }
        },
      ),
    );
  }

  Widget _buildEditableInfoRow(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor ingrese $label';
          }
          return null;
        },
      ),
    );
  }
}
