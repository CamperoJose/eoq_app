import 'package:flutter/material.dart';
import '../Componentes/button1.dart';
import '../Componentes/text_field1.dart';
import 'calculator.dart';

class LoginView extends StatelessWidget {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpaper01.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                screenWidth > 600 // pantalla más grande que un iPad horizontal
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.asset(
                              'assets/logo01.png',
                              width: 400,
                              height: 400,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextInput1(
                                  controller: _userController,
                                  hint: "Ingrese su usuario",
                                  obscureText: false,
                                ),
                                const SizedBox(height: 20),
                                TextInput1(
                                  controller: _passwordController,
                                  hint: "Ingrese su contraseña",
                                  obscureText: true,
                                ),
                                const SizedBox(height: 20),
                                CustomElevatedButton(
                                  buttonText: "Ingresar",
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CalculatorView()));
                                  },
                                ),
                                const SizedBox(
                                    height:
                                        20), // Añadir espacio entre botón y texto
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo01.png',
                            width: 200,
                            height: 200,
                          ),
                          const SizedBox(height: 20),
                          TextInput1(
                            controller: _userController,
                            hint: "Ingrese su usuario",
                            obscureText: false,
                          ),
                          const SizedBox(height: 20),
                          TextInput1(
                            controller: _passwordController,
                            hint: "Ingrese su contraseña",
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          CustomElevatedButton(
                            buttonText: "Ingresar",
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CalculatorView()));
                            },
                          ),
                          const SizedBox(
                              height: 20), // Añadir espacio entre botón y texto
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}
