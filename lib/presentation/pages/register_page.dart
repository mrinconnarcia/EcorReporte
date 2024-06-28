import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/entities/user.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'usuario'; // Default role
  bool _obscureText = true;
  String? _errorMessage;

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Registro'),
  //       backgroundColor: Colors.white,
  //       foregroundColor: Colors.black,
  //       elevation: 0,
  //     ),
  //     body: Center(
  //       child: SingleChildScrollView(
  //         child: ConstrainedBox(
  //           constraints: BoxConstraints(maxWidth: 400),
  //           child: Padding(
  //             padding: const EdgeInsets.all(20.0),
  //             child: Form(
  //               key: _formKey,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 children: [
  //                   Text(
  //                     'Registro',
  //                     style:
  //                         TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   SizedBox(height: 30),
  //                   TextFormField(
  //                     controller: _nameController,
  //                     decoration: InputDecoration(
  //                       labelText: 'Nombre',
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                     ),
  //                     validator: (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Por favor ingrese su nombre';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   SizedBox(height: 20),
  //                   TextFormField(
  //                     controller: _emailController,
  //                     decoration: InputDecoration(
  //                       labelText: 'Email',
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                     ),
  //                     validator: (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Por favor ingrese su email';
  //                       }
  //                       if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
  //                           .hasMatch(value)) {
  //                         return 'Por favor ingrese un email válido';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   SizedBox(height: 20),
  //                   TextFormField(
  //                     controller: _passwordController,
  //                     decoration: InputDecoration(
  //                       labelText: 'Contraseña',
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                       suffixIcon: IconButton(
  //                         icon: Icon(_obscureText
  //                             ? Icons.visibility_off
  //                             : Icons.visibility),
  //                         onPressed: () {
  //                           setState(() {
  //                             _obscureText = !_obscureText;
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                     obscureText: _obscureText,
  //                     validator: (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Por favor ingrese su contraseña';
  //                       }
  //                       if (value.length < 6) {
  //                         return 'La contraseña debe tener al menos 6 caracteres';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   SizedBox(height: 20),
  //                   DropdownButtonFormField<String>(
  //                     value: _selectedRole,
  //                     decoration: InputDecoration(
  //                       labelText: 'Rol',
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                     ),
  //                     items: [
  //                       DropdownMenuItem(
  //                           value: 'usuario', child: Text('Usuario')),
  //                       DropdownMenuItem(value: 'admin', child: Text('Admin')),
  //                     ],
  //                     onChanged: (value) {
  //                       setState(() {
  //                         _selectedRole = value!;
  //                       });
  //                     },
  //                     validator: (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return 'Por favor seleccione un rol';
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                   SizedBox(height: 30),
  //                   if (_errorMessage != null)
  //                     Text(
  //                       _errorMessage!,
  //                       style: TextStyle(color: Colors.red),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   SizedBox(height: 20),
  //                   ElevatedButton(
  //                     onPressed: _register,
  //                     child: Text('Registrarse'),
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: Colors.blue,
  //                       foregroundColor: Colors.white,
  //                       minimumSize: Size(double.infinity, 50),
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(8),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(height: 20),
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.pushNamed(context, '/login');
  //                     },
  //                     child: Text(
  //                       '¿Ya tienes una cuenta? Iniciar sesión',
  //                       style: TextStyle(color: Colors.green),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FocusScope(
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Por favor ingrese un email válido';
                            }
                            return null;
                          },
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
                                  ? Icons.visibility_off
                                  : Icons.visibility),
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
                            }
                            if (value.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
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
                          items: [
                            DropdownMenuItem(
                                value: 'usuario', child: Text('Usuario')),
                            DropdownMenuItem(
                                value: 'admin', child: Text('Admin')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor seleccione un rol';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        if (_errorMessage != null)
                          Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _register,
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
                            Navigator.pushNamed(context, '/login');
                          },
                          child: Text(
                            '¿Ya tienes una cuenta? Iniciar sesión',
                            style: TextStyle(color: Colors.green),
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
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userRepository =
            Provider.of<UserRepository>(context, listen: false);
        final user = User(
          // id: 0, // Assuming ID is auto-generated
          nombre: _nameController.text,
          email: _emailController.text,
          rol: _selectedRole,
        );

        final result =
            await userRepository.register(user, _passwordController.text);

        if (result == true) {
          Navigator.pushNamed(context, '/home-app');
        } else {
          setState(() {
            _errorMessage =
                'Error al registrar. Por favor, inténtelo de nuevo.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error al registrar. Por favor, inténtelo de nuevo.';
        });
      }
    }
  }
}
