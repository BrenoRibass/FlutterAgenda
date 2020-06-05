import 'package:agenda_contatos/storage/bancodedados.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PagContato extends StatefulWidget {
  final Contact contato;
  PagContato({this.contato});
  @override
  _PagContatoState createState() => _PagContatoState();
}

class _PagContatoState extends State<PagContato> {
  Contact _ContatoEditado;
  final _controladorNome = TextEditingController();
  final _controladorEmail = TextEditingController();
  final _controladorNum = TextEditingController();

  /* FUNÇÕES ---- INÍCIO*/

  void _opcoes() {
    /*Lista as opções para inserção da imagem entre câmera e galeria*/
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Tirar foto pela câmera",
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                        onPressed: () {
                          ImagePicker.pickImage(source: ImageSource.camera)
                              .then((imagem) {
                            if (imagem != null) {
                              setState(() {
                                _ContatoEditado.img = imagem.path;
                                Navigator.pop(context);
                              });
                            } else {
                              return;
                              setState(() {
                                Navigator.pop(context);
                              });
                            }
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Escolher imagem a partir da galeria",
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                        onPressed: () {
                          ImagePicker.pickImage(source: ImageSource.gallery)
                              .then((imagem) {
                            if (imagem != null) {
                              setState(() {
                                _ContatoEditado.img = imagem.path;
                                Navigator.pop(context);
                              });
                            } else {
                              return;
                              setState(() {
                                Navigator.pop(context);
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  @override
  void initState() {
    super.initState();
    if (widget.contato == null) {

      _ContatoEditado = Contact();
    } else {
      _ContatoEditado = Contact.fromMap(widget.contato.toMap());
      /*Se receber um contato da inicial, carrega seus dados para os
      controladores preenchendo os campos*/
      _controladorNum.text = _ContatoEditado.phone;
      _controladorEmail.text = _ContatoEditado.email;
      _controladorNome.text = _ContatoEditado.name;
    }
  }
  /* FUNÇÕES---- FIM*/




  /* WIDGETS ---- INÍCIO*/
  Widget _Alerta() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Calma lá amigão'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Preencha os dados necessários!'),
                Text('Informe seu nome e número de telefone'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Retornar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  /* WIDGETS ---- FIM*/





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Container(
            height: 50.0,
            child: Image.network(
                "https://www.digcoin.com.br/images/logoHorizontall200_200.png"),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.orange, Colors.white, Colors.orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {
            print("tappado");
            /*Valida os dados, permitindo ser salvo um contato*/
            if ((_ContatoEditado.name != null && _ContatoEditado.name != "") &&
                (_ContatoEditado.phone != null &&
                    _ContatoEditado.phone != "")  &&
                (_ContatoEditado.email != null &&
                    _ContatoEditado.email != ""))  {
              Navigator.pop(context, _ContatoEditado);
            } else {
              setState(() {
               /*Inicia um alertbox avisando sobre os dados*/
                _Alerta();
              });
            }
            print("tappado");
          },
          child: Icon(Icons.save),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(12.0),
            child: Column(children: <Widget>[
              GestureDetector(

                  onTap: () {
                    _opcoes();
                  },
                  child: Expanded(
                    child: Container(
                      width: 300.0,
                      height: 300.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: _ContatoEditado.img != null
                                ? FileImage(File(_ContatoEditado.img))
                                : AssetImage("images/person.png"),
                            /*Se imagem existir*/
                            fit: BoxFit.cover),
                      ),
                    ),
                  )),
              TextField(
                controller: _controladorNome,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (msg) {

                  setState(() {
                    _ContatoEditado.name = msg;
                  });
                },
              ),
              TextField(
                controller: _controladorEmail,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                onChanged: (msg) {

                  _ContatoEditado.email = msg;
                },
              ),
              TextField(
                controller: _controladorNum,
                decoration: InputDecoration(labelText: "Telefone"),
                keyboardType: TextInputType.phone,
                onChanged: (msg) {

                  _ContatoEditado.phone = msg;
                },
              ),
            ])));
  }
}
