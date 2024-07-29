import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../bloc/authentication_bloc.dart';
import '../bloc/authentication_event.dart';
import '../bloc/authentication_state.dart';
import '../../domain/entities/user.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  String _selectedGender = 'Masculino';
  String _selectedRole = 'usuario';
  bool _obscureText = true;
  bool _acceptTerms = false;
  String? _errorMessage;

  bool isEmailValid(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  bool isPasswordValid(String password) {
    return password.length >= 6;
  }

  bool isPhoneValid(String phone) {
    final regex = RegExp(r'^\+?[0-9]{7,15}$');
    return regex.hasMatch(phone);
  }

  // void _showTermsAndConditions() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         contentPadding:
  //             EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0), // Ajuste de padding
  //         title: Container(
  //           padding: EdgeInsets.all(20.0), // Espaciado interior para el título
  //           child: Text('Términos y Condiciones', textAlign: TextAlign.center),
  //         ),
  //         content: Container(
  //           width: double.maxFinite, // Ancho máximo posible
  //           constraints: BoxConstraints(
  //               maxHeight:
  //                   MediaQuery.of(context).size.height * 0.85), // Máximo alto
  //           child: SingleChildScrollView(
  //             child: Text(
  //               '''Políticas de Privacidad de Eco-Reporte

  //                 Eco-Reporte, con domicilio en Calle Sin Nombre, Sin Número, Colonia Distrito Federal, Chiapa de Corzo, Chiapas, 29179, México, y correo electrónico innobytesoftw@gmail.com, es responsable del uso y protección de sus datos personales.

  //                 **Fines del uso de sus datos personales:**
  //                 1. **Gestión y resolución de reportes ecológicos:** Para registrar reportes de problemas ecológicos y asignar los casos a las autoridades competentes.
  //                 2. **Comunicación con autoridades y administradores:** Para mantener una comunicación eficiente sobre el estado de su reporte y responder consultas.
  //                 3. **Seguimiento y actualización de reportes ecológicos:** Para monitorear el progreso y estado de los reportes.

  //                 **Fines adicionales:**
  //                 1. **Envío de información y material educativo:** Con su consentimiento, para enviarle boletines y material educativo sobre temas ecológicos.
  //                 2. **Realización de encuestas:** Para mejorar nuestros servicios mediante encuestas y estudios de opinión.

  //                 **Consulta del aviso de privacidad integral:**
  //                 Para más información sobre el tratamiento de sus datos personales, puede consultar nuestro aviso de privacidad integral en:
  //                 - **Página web:** [EcoReporte](https://eco-reporte-f44a0.web.app)
  //                 - **Correo electrónico:** Solicitándolo a innobytesoftw@gmail.com
  //                 - **Teléfono:** 9613315517
  //                 - **Oficinas físicas:** Calle Sin Nombre, Sin Número, Colonia Distrito Federal, Chiapa de Corzo, Chiapas, 29179, México.

  //                 Nos comprometemos a informarle sobre cualquier cambio significativo en nuestro aviso de privacidad. En caso de modificaciones, le notificaremos a través de los medios de contacto proporcionados y actualizaremos el documento en nuestra página web.
  //                 ''',
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Cerrar'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showTermsAndConditions() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: 'Términos y Condiciones',
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '''Políticas de Privacidad de Eco-Reporte

            Eco-Reporte, con domicilio en Calle Sin Nombre, Sin Número, Colonia Distrito Federal, Chiapa de Corzo, Chiapas, 29179, México, y correo electrónico innobytesoftw@gmail.com, es responsable del uso y protección de sus datos personales.

            Fines del uso de sus datos personales:
            1. Gestión y resolución de reportes ecológicos: Para registrar reportes de problemas ecológicos y asignar los casos a las autoridades competentes.
            2. Comunicación con autoridades y administradores: Para mantener una comunicación eficiente sobre el estado de su reporte y responder consultas.
            3. Seguimiento y actualización de reportes ecológicos: Para monitorear el progreso y estado de los reportes.

            Fines adicionales:
            1. Envío de información y material educativo: Con su consentimiento, para enviarle boletines y material educativo sobre temas ecológicos.
            2. Realización de encuestas: Para mejorar nuestros servicios mediante encuestas y estudios de opinión.

            Consulta del aviso de privacidad integral:
            Para más información sobre el tratamiento de sus datos personales, puede consultar nuestro aviso de privacidad integral en:
            - Página web: EcoReporte (https://eco-reporte-f44a0.web.app)
            - Correo electrónico: Solicitándolo a innobytesoftw@gmail.com
            - Teléfono: 9613315517
            - Oficinas físicas: Calle Sin Nombre, Sin Número, Colonia Distrito Federal, Chiapa de Corzo, Chiapas, 29179, México.

            Nos comprometemos a informarle sobre cualquier cambio significativo en nuestro aviso de privacidad. En caso de modificaciones, le notificaremos a través de los medios de contacto proporcionados y actualizaremos el documento en nuestra página web.''',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
      btnOkOnPress: () {},
      btnOkText: 'Entendido',
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationSuccess2) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.bottomSlide,
              title: 'Registro Exitoso',
              desc: '¡Te has registrado exitosamente!',
              btnOkOnPress: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
            )..show();
          } else if (state is AuthenticationFailure) {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.rightSlide,
              title: 'Error de Registro',
              desc: state.message,
              btnOkOnPress: () {},
              btnOkColor: Colors.red,
            )..show();
          }
        },
        child: FocusScope(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Registro',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Nombre',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su nombre';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Apellido',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su apellido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Correo electrónico',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su correo electrónico';
                              } else if (!isEmailValid(value)) {
                                return 'Por favor ingrese un correo electrónico válido';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            ),
                            obscureText: _obscureText,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su contraseña';
                              } else if (!isPasswordValid(value)) {
                                return 'La contraseña debe tener al menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Número de teléfono',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su número de teléfono';
                              } else if (!isPhoneValid(value)) {
                                return 'Por favor ingrese un número de teléfono válido';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            decoration: InputDecoration(
                              labelText: 'Género',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items:
                                ['Masculino', 'Femenino', 'Otro'].map((gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            decoration: InputDecoration(
                              labelText: 'Rol',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: ['usuario', 'admin'].map((role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value!;
                                if (_selectedRole == 'admin') {
                                  _codeController.text = '';
                                }
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _codeController,
                            enabled: _selectedRole == 'usuario',
                            decoration: InputDecoration(
                              labelText: 'Código',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (_selectedRole == 'usuario' &&
                                  (value == null || value.isEmpty)) {
                                return 'Por favor ingrese su código';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: _acceptTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _acceptTerms = value!;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showTermsAndConditions();
                                },
                                child: Text(
                                  'Acepto los Términos y Condiciones',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          if (_errorMessage != null)
                            Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (!_acceptTerms) {
                                  setState(() {
                                    _errorMessage =
                                        'Debe aceptar los términos y condiciones';
                                  });
                                  return;
                                }
                                final user = User(
                                  name: _nameController.text,
                                  lastName: _lastNameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  gender: _selectedGender,
                                  role: _selectedRole,
                                  code: _codeController.text,
                                );
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(RegisterEvent(
                                        user, _passwordController.text));
                              }
                            },
                            child: Text('Registrarse'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed('/login');
                            },
                            child: Text('¿Ya tienes una cuenta? Inicia sesión',
                                style: TextStyle(color: Colors.green)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
