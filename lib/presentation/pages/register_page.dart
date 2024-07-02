import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
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
  String _selectedGender = 'Masculino'; // Default gender
  String _selectedRole = 'usuario'; // Default role
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

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Términos y Condiciones'),
          content: SingleChildScrollView(
            child: Text(
              '''Villazón Rico Leonardo Jesús, con  domicilio en Calle Francisco I Madero No. 55 Despacho 424 4to Piso Col. Centro Delegación  Cuauhtémoc  C.P. 06000 México Ciudad de México. Hace de su conocimiento que los datos personales de usted, que actualmente o en el futuro obren en nuestra base de datos, ya sea por formar parte de nuestro grupo de clientes o ser alguno de nuestros proveedores, serán tratados y/o utilizados por: Villazón Rico Leonardo Jesús, con el propósito de cumplir aquellas obligaciones que se derivan de la relación jurídica existente entre usted como titular de los datos personales y las empresa antes señalada.
              Villazón Rico Leonardo Jesús en los  casos de excepción  previsto en el artículo 37 de la Ley Federal de Protección de Datos Personales en Posesión  de Particulares y en los artículos 18 fracción V, 21,22,23 y 24 de la Ley Federal para la Prevención e Identificación de Operaciones con Recursos de Procedencia Ilícita, podrá transferir sus datos personales, toda vez que los productos que Villazón Rico Leonardo Jesús comercializa son  considerados por esta Ley,  como actividades vulnerables y por tanto sujetas a dicha normatividad.
              Los datos que almacenamos en nuestra base de datos serán tratados de conformidad con la Ley Federal de Protección de Datos Personales en Posesión de los Particulares y su Reglamento, y la información está garantizada y protegida por medidas de seguridad administrativas, técnicas y físicas, para evitar su daño, pérdida, alteración, destrucción, uso, acceso o divulgación indebida. Para conocer dichos procedimientos se puede poner en  contacto con nosotros cullinans@hotmail.com y 5555120772.
              Su información será utilizada para proporcionarle un  mejor servicio y, en particular por las siguientes razones:
              Mantenimiento de registros internos y  alta de clientes.
              Para mejorar nuestros productos  y servicios,
              Para comunicarnos con usted por correo electrónico, teléfono si nos ha hecho pedidos o comprado productos, sea acerca del pedido o la compra u otros asuntos relacionados con transacciones entre nosotros o su relación como cliente nuestro.
              Atender quejas y aclaraciones, y en su caso, tratarlos para fines compatibles con los mencionados en este Aviso de Privacidad y que se consideren análogos para efectos legales. En caso de formalizar con Usted la aceptación de algún producto o servicio ofrecido.  Sus datos serán utilizados para el cumplimiento de las obligaciones derivadas de esa relación jurídica.
              Para proporcionar referencias comerciales.
              Cuando usted solicite un crédito o financiamiento.
              
              Para las finalidades antes mencionadas, requerimos obtener los siguientes datos personales : Nombre Completo, empresa en la que labora, cargo que ocupa, correo electrónico, números telefónicos, Registro Federal de Contribuyentes, Domicilio fiscal y personal,  para procesar su solicitud de crédito  o financiamiento se le puede pedir referencias personales y comerciales.
              No divulgaremos su información personal a terceros para sus propios propósitos de marketing.

              Por otra parte, hacemos de su conocimiento que en cualquier momento podrá ejercer los derechos de acceso, rectificación, cancelación u oposición al tratamiento de sus Datos, presentando su solicitud a través del correo electrónico: cullinans@hotmail.com debiendo recabar el acuse de recibo correspondiente. Todas las solicitudes que sean presentadas a Villazón Rico Leonardo Jesús, independiente del medio utilizado por los titulares, deberán:
              Incluir el nombre y firma autógrafa del titular, así como un domicilio u otro medio para comunicarle la respuesta a su solicitud.
              Acompañar los documentos oficiales que acrediten la identidad de titular.
              Incluir una descripción clara y precisa de los datos personales respecto de los cuales ejercitará los derechos que les confiere la Ley.
              Incluir cualquier elemento o documento que facilite la localización de los datos personales de que se traten.
              Se entenderá que usted como titular consiente tácitamente el tratamiento de sus datos personales conforme a lo enunciado en el presente aviso de privacidad, cuando habiéndolo puesto a su disposición, no manifieste su oposición. 
              Villazón Rico Leonardo Jesús se reserva el derecho de cambiar, modificar, complementar y/o alterar el presente Aviso, en cualquier momento, en cuyo caso se hará de su conocimiento a través de cualquiera de los medios que establece la legislación en la materia.
              ''',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
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
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su email';
                            }
                            if (!isEmailValid(value)) {
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
                            if (!isPasswordValid(value)) {
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
                            }
                            if (!isPhoneValid(value)) {
                              return 'Por favor ingrese un teléfono válido';
                            }
                            return null;
                          },
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
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedGender = newValue!;
                            });
                          },
                          items: <String>['Masculino', 'Femenino', 'Otro']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor seleccione su género';
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
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRole = newValue!;
                            });
                          },
                          items: <String>['usuario', 'admin']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (bool? value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: _showTermsAndConditions,
                                child: Text(
                                  'Acepto los términos y condiciones',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!_acceptTerms)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Debes aceptar los términos y condiciones para registrarte',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        SizedBox(height: 20),
                        BlocConsumer<AuthenticationBloc, AuthenticationState>(
                          listener: (context, state) {
                            if (state is AuthenticationSuccess) {
                              Navigator.of(context).pushReplacementNamed('/home-app');
                            } else if (state is AuthenticationFailure) {
                              setState(() {
                                _errorMessage = state.message;
                              });
                            }
                          },
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    _acceptTerms) {
                                  BlocProvider.of<AuthenticationBloc>(context).add(
                                    RegisterEvent(
                                      User(
                                        name: _nameController.text,
                                        lastName: _lastNameController.text,
                                        email: _emailController.text,
                                        role: _selectedRole,
                                        gender: _selectedGender,
                                        phone: _phoneController.text,
                                      ),
                                      _passwordController.text,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Registrar'),
                            );
                          },
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
}
