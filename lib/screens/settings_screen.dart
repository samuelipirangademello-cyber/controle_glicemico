import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_theme.dart';
import '../repository/local_glycemia_repository.dart';
import '../services/google_sheets_service.dart';

class SettingsScreen extends StatefulWidget { final LocalGlycemiaRepository repository; const SettingsScreen({super.key,required this.repository}); @override State<SettingsScreen> createState()=>_SettingsScreenState(); }
class _SettingsScreenState extends State<SettingsScreen>{
  final client=TextEditingController(); final sheet=TextEditingController(); final tab=TextEditingController(text:'A:E');
  final google=GoogleSheetsService(); bool busy=false; String status='Não conectado';
  @override void initState(){super.initState();_load();}
  Future<void> _load() async {final p=await SharedPreferences.getInstance();client.text=p.getString('google_server_client_id')??'';sheet.text=p.getString('google_spreadsheet_id')??'';tab.text=p.getString('google_sheet_range')??'A:E';}
  Future<void> _save() async {final p=await SharedPreferences.getInstance();await p.setString('google_server_client_id',client.text.trim());await p.setString('google_spreadsheet_id',sheet.text.trim());await p.setString('google_sheet_range',tab.text.trim());}
  Future<void> _connect(){return _run(() async{await _save();final u=await google.connect(serverClientId:client.text);setState(()=>status='Conectado: ${u.email}');});}
  Future<void> _sync() async {await _run(() async{await _save();final records=await google.readRecords(spreadsheetId:sheet.text,range:tab.text);await widget.repository.replaceAll(records);setState(()=>status='Sincronizado: ${records.length} registros');});}
  Future<void> _run(Future<void> Function() action) async{setState(()=>busy=true);try{await action();if(mounted&&status=='Não conectado')setState(()=>status='Concluído');}catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(e.toString().replaceFirst('Bad state: ',''))));}finally{if(mounted)setState(()=>busy=false);}}
  @override void dispose(){client.dispose();sheet.dispose();tab.dispose();super.dispose();}
  @override Widget build(BuildContext context)=>SafeArea(child:ListView(padding:const EdgeInsets.fromLTRB(20,24,20,110),children:[
    const Text('Configurações',style:TextStyle(fontSize:30,fontWeight:FontWeight.w800,color:AppColors.brandDeep)),const SizedBox(height:4),const Text('Conexão e preferências do aplicativo.',style:TextStyle(fontSize:15,color:AppColors.muted,fontWeight:FontWeight.w600)),const SizedBox(height:20),
    _Card(icon:Icons.cloud_outlined,title:'Google Sheets',child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      _field(client,'ID do cliente OAuth Web','Ex.: 123...apps.googleusercontent.com'),const SizedBox(height:10),_field(sheet,'ID da planilha','O código entre /d/ e /edit na URL da planilha'),const SizedBox(height:10),_field(tab,'Intervalo','Normalmente A:E'),const SizedBox(height:14),
      SizedBox(width:double.infinity,height:48,child:ElevatedButton.icon(onPressed:busy?null:_connect,icon:const Icon(Icons.login),label:const Text('CONECTAR GOOGLE',style:TextStyle(fontWeight:FontWeight.w800)),style:ElevatedButton.styleFrom(backgroundColor:AppColors.brand,foregroundColor:Colors.white,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14))))),const SizedBox(height:10),
      SizedBox(width:double.infinity,height:48,child:OutlinedButton.icon(onPressed:busy?null:_sync,icon:const Icon(Icons.sync),label:const Text('SINCRONIZAR PLANILHA',style:TextStyle(fontWeight:FontWeight.w800)),style:OutlinedButton.styleFrom(foregroundColor:AppColors.brandDeep,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14))))),const SizedBox(height:10),Text(status,style:const TextStyle(color:AppColors.muted,fontSize:12.5,fontWeight:FontWeight.w600)),
    ])),const SizedBox(height:14),
    const _Card(icon:Icons.notifications_none_rounded,title:'Notificações',child:Text('Lembretes e alertas poderão ser adicionados depois, sem alterar o registro das medições.',style:TextStyle(color:AppColors.muted,height:1.4))),const SizedBox(height:14),
    const _Card(icon:Icons.info_outline_rounded,title:'Sobre o aplicativo',child:Text('Controle Glicêmico • versão 0.2.0\nRegistro local, relatórios por período e integração preparada para Google Sheets.',style:TextStyle(color:AppColors.muted,height:1.4))),const SizedBox(height:14),
    const _Card(icon:Icons.lock_outline_rounded,title:'Privacidade',child:Text('A planilha não precisa ser pública. O acesso usa autorização da sua conta Google e o aplicativo solicita o acesso à API do Sheets.',style:TextStyle(color:AppColors.muted,height:1.4))),
  ]));
  Widget _field(TextEditingController c,String label,String hint)=>TextField(controller:c,decoration:InputDecoration(labelText:label,hintText:hint,border:OutlineInputBorder(borderRadius:BorderRadius.circular(14)),isDense:true));
}
class _Card extends StatelessWidget{final IconData icon;final String title;final Widget child;const _Card({required this.icon,required this.title,required this.child});@override Widget build(BuildContext c)=>Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:AppColors.surface,border:Border.all(color:AppColors.line),borderRadius:BorderRadius.circular(20)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Container(width:44,height:44,decoration:BoxDecoration(color:AppColors.brandSoft,borderRadius:BorderRadius.circular(14)),child:Icon(icon,color:AppColors.brandDeep)),const SizedBox(width:12),Text(title,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800,color:AppColors.brandDeep))]),const SizedBox(height:14),child]));}
