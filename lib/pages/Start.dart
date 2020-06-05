import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:agenda_contatos/storage/bancodedados.dart';
import 'package:flutter/material.dart';
import 'package:agenda_contatos/pages/contato.dart';
/*Tela inicial do aplicativo*/

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  ContactHelper helper = ContactHelper();
  List<Contact> contatos = List();
  int decider = 0;

  void _PegarContatos() {
    helper.getAllContacts().then((list) {
      setState(() {
        contatos = list;
        decider = contatos.length;
      });
    });
  }
/* FUNÇÕES ----- INÍCIO*/
  void _opcoes(BuildContext context, int index) {
    /*Abre a caixa de diálogo que tem as opções de ir à página de
     visualização /edição, ligar e excluir o contato   */
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
                          "Visualizar",
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _RecebeContato(contact: contatos[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Ligar",
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                        onPressed: () {
                          launch("tel:${contatos[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                        onPressed: () {
                          helper.deleteContact(contatos[index].id);
                          setState(() {
                            contatos.removeAt(index);
                            Navigator.pop(context);
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


  void _RecebeContato({Contact contact}) async {
    /*  Recebe o contato da página de edição / visualização e toma a decisão
    entre atualizar um contato existente ou criar */
    final contatorecebido = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => PagContato(contato: contact)));
    if (contatorecebido != null) {
      if (contact != null) {
        /*Se o contato existir ele irá ser atualizado*/
        await helper.updateContact(contatorecebido);
        _PegarContatos();
      } else {
        /*Cria um novo contato*/
        await helper.saveContact(contatorecebido);
        _PegarContatos();
      }
    }
  }
 /* FUNÇÕES ---- FIM*/




  /* WIDGETS ---- INÍCIO*/

  Widget _cardContato(BuildContext context, int index) {
    /*Contem o card com o contato*/
    return GestureDetector(
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contatos[index].img != null
                          ? FileImage(File(contatos[index].img))
                          : AssetImage("images/person.png"),
                      /*Carrega uma imagem padrão caso a do usuário não exista*/
                      fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          contatos[index].name ?? "Nome indisponível",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.email,
                          size: 15.0,
                        ),
                        Text(
                          " " + contatos[index].email ?? "Email indisponível",
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.phone,
                          size: 15.0,
                        ),
                        Text(
                          " " + contatos[index].phone ??
                              "Telefone indisponível",
                          style: TextStyle(fontSize: 15.0),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        // _RecebeContato(contact: contatos[index]);
        _opcoes(context, index);
      },
    );
  }
  /* WIDGETS ---- FIM */








  @override
  void initState() {
    super.initState();
    _PegarContatos();
    /*Carrega os contatos do banco de dados*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50.0,
          child: Image.network(
              "https://www.digcoin.com.br/images/logoHorizontall200_200.png"),
        ),
        backgroundColor: Colors.white,
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
        onPressed: () {
          _RecebeContato();
        },
        child: Icon(
          Icons.person_add,
          color: Colors.orange,
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.orange, Color.fromRGBO(255, 79, 0, 1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: contatos.length,
            itemBuilder: (context, index) {
              return _cardContato(context, index);
            }),
      ),
    );
  }
}
