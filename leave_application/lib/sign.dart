import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:leave_application/utils/api.dart';

SizedBox loading() {
  return SizedBox(
    width: 20,
    height: 20,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      color: Colors.white, // matches button text color
    ),
  );
}


class SignPage extends StatelessWidget {
  const SignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SignApp();
  }
}

class SignApp extends StatefulWidget {
  const SignApp({super.key});

  @override
  State<SignApp> createState() => _SignAppState();
}

class _SignAppState extends State<SignApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('xyz'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: "Login"), Tab(text: "Sign up")],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [Login(), SignUp()],
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final emailCtl = TextEditingController();
  final nameCtl = TextEditingController();
  final pass = TextEditingController();
  final conpas = TextEditingController();
  late bool _obscure;
  bool _isloading = false;
  @override
  void initState() {
    super.initState();
    _obscure = true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameCtl,
              decoration: InputDecoration(labelText: "name"),
              keyboardType: TextInputType.name,
              validator:
                  (v) =>
                      v != null && v.length >= 3
                          ? null
                          : "Name must more than 3",
            ),
            TextFormField(
              controller: emailCtl,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
              validator:
                  (v) =>
                      v != null && v.contains("@")
                          ? null
                          : "Enter a valid email",
            ),
            TextFormField(
              controller: pass,
              decoration: InputDecoration(labelText: "password"),
              obscureText: true,
              validator:
                  (v) =>
                      v != null && v.length >= 6
                          ? null
                          : "Password must more than 6",
            ),
            TextFormField(
              controller: conpas,
              decoration: InputDecoration(
                labelText: "confirm",
                suffixIcon: IconButton(
                  icon:
                      _obscure
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                ),
              ),
              obscureText: _obscure,
              validator: (value) {
                if (value != pass.text) {
                  return "password must be same";
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed:
                  _isloading
                      ? null
                      : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isloading = true;
                          });

                          final Map<String, String> body = {
                            "email": emailCtl.text,
                            "name": nameCtl.text,
                            "password": pass.text,
                          };
                          // log(jsonEncode(body));

                             await signup(context,body);
                          setState(() {
                            _isloading = false;
                          });
                        }
                      },
              child: _isloading ? loading() : Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

}

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final form = GlobalKey<FormState>();
  final emailCtl = TextEditingController();
  final passCtl = TextEditingController();
  late bool obscure;
  @override
  void initState() {
    super.initState();
    obscure = true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: Center(
        child: Column(
          children: [
            TextFormField(
              controller: emailCtl,
              decoration: InputDecoration(hintText: "email"),
            ),
            TextFormField(
              controller: passCtl,
              obscureText: obscure,
              decoration: InputDecoration(
                hintText: "Password",
                suffixIcon: IconButton(
                  icon:
                      obscure
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                log("sub");
                if (form.currentState!.validate()) {
                  final body = {
                    "email": emailCtl.text,
                    "password": passCtl.text,
                  };
                 await login(context,body);
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

 
}
