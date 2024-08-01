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

  String sanitizeInput(String input) {
    final whitelist = RegExp(r'^[a-zA-Z0-9@.]+$');
    return whitelist.hasMatch(input) ? input : '';
  }

  String blacklistInput(String input) {
    final blacklist = RegExp(r'[<>!@#$%^&*()_+=\[\]{};:"\\|,.<>\/?~]');
    return input.replaceAll(blacklist, '');
  }

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
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscureText,
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
                              labelText: 'Teléfono',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su teléfono';
                              } else if (!isPhoneValid(value)) {
                                return 'Por favor ingrese un teléfono válido';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: _selectedGender,
                            items: [
                              DropdownMenuItem(
                                child: Text('Masculino'),
                                value: 'Masculino',
                              ),
                              DropdownMenuItem(
                                child: Text('Femenino'),
                                value: 'Femenino',
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Género',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            items: [
                              DropdownMenuItem(
                                child: Text('Usuario'),
                                value: 'usuario',
                              ),
                              DropdownMenuItem(
                                child: Text('Administrador'),
                                value: 'administrador',
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Rol',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _codeController,
                            decoration: InputDecoration(
                              labelText: 'Código (opcional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          CheckboxListTile(
                            title: GestureDetector(
                              onTap: _showTermsAndConditions,
                              child: Text(
                                'Aceptar términos y condiciones',
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            value: _acceptTerms,
                            onChanged: (value) {
                              setState(() {
                                _acceptTerms = value!;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  _acceptTerms) {
                                // Obtener los datos del formulario
                                String name = sanitizeInput(_nameController.text.trim());
                                String lastName = sanitizeInput(_lastNameController.text.trim());
                                String email = sanitizeInput(_emailController.text.trim().toLowerCase());
                                String password = _passwordController.text.trim();
                                String phone = _phoneController.text.trim();
                                String code = _codeController.text.trim();
                                String gender = _selectedGender;
                                String role = _selectedRole;

                                User user = User(
                                  name: name,
                                  lastName: lastName,
                                  email: email,
                                  phone: phone,
                                  gender: gender,
                                  role: role,
                                  code: code,
                                );

                                BlocProvider.of<AuthenticationBloc>(context).add(RegisterEvent(user, password));
                              } else {
                                setState(() {
                                  _errorMessage =
                                      'Por favor complete todos los campos correctamente y acepte los términos y condiciones';
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text('Registrarse'),
                          ),
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
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
