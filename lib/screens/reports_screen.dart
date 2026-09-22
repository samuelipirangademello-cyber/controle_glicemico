import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/glycemia_record.dart';
import '../repository/glycemia_repository.dart';
import '../services/report_service.dart';

class ReportsScreen extends StatefulWidget {
  final GlycemiaRepository repository;
  const ReportsScreen({super.key, required this.repository});
  @override State<ReportsScreen> createState() => _ReportsScreenState();
}
class _ReportsScreenState extends State<ReportsScreen> {
  late Future<List<GlycemiaRecord>> _future;
  DateTime? start;
  DateTime? end;
  @override void initState(){super.initState(); _future=widget.repository.getRecords();}
  String _fmt(DateTime d)=>'${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}/${d.year}';
  Future<void> _pick(bool isStart) async {
    final now=DateTime.now();
    final initial=isStart ? (start ?? DateTime(now.year,now.month,1)) : (end ?? now);
    final picked=await showDatePicker(context:context, initialDate:initial, firstDate:DateTime(2020), lastDate:DateTime(now.year+1,12,31), helpText:isStart?'DATA INICIAL':'DATA FINAL');
    if(picked==null) return;
    setState(() { if(isStart) start=DateTime(picked.year,picked.month,picked.day); else end=DateTime(picked.year,picked.month,picked.day,23,59,59); });
  }
  void _quick(int days){ final now=DateTime.now(); setState((){ end=DateTime(now.year,now.month,now.day,23,59,59); start=DateTime(now.year,now.month,now.day).subtract(Duration(days:days-1)); }); }
  List<GlycemiaRecord> _filtered(List<GlycemiaRecord> all){ if(start==null||end==null) return all; return all.where((r)=>!r.dateTime.isBefore(start!)&&!r.dateTime.isAfter(end!)).toList(); }
  @override Widget build(BuildContext context)=>SafeArea(child:FutureBuilder<List<GlycemiaRecord>>(future:_future,builder:(context,s){
    if(!s.hasData) return const Center(child:CircularProgressIndicator(color:AppColors.brand));
    final all=s.data!; final data=_filtered(all)..sort((a,b)=>a.dateTime.compareTo(b.dateTime));
    final avg=data.isEmpty?0:data.map((r)=>r.glycemia).reduce((a,b)=>a+b)/data.length;
    final min=data.isEmpty?0:data.map((r)=>r.glycemia).reduce((a,b)=>a<b?a:b); final max=data.isEmpty?0:data.map((r)=>r.glycemia).reduce((a,b)=>a>b?a:b);
    return ListView(padding:const EdgeInsets.fromLTRB(20,24,20,110),children:[
      const Text('Relatórios',style:TextStyle(fontSize:30,fontWeight:FontWeight.w800,color:AppColors.brandDeep)),
      const SizedBox(height:4), const Text('Escolha o período e gere o relatório completo.',style:TextStyle(fontSize:15,color:AppColors.muted,fontWeight:FontWeight.w600)),
      const SizedBox(height:20),
      _Card(title:'Período',child:Column(children:[
        Row(children:[Expanded(child:_dateButton('Data inicial',start,_pick,true)),const SizedBox(width:10),Expanded(child:_dateButton('Data final',end,_pick,false))]),
        const SizedBox(height:12),
        Wrap(spacing:8,runSpacing:8,children:[_quickButton('7 dias',7),_quickButton('30 dias',30),_quickButton('Este mês',DateTime.now().day)]),
      ])),
      const SizedBox(height:14),
      _Card(title:'Resumo do período',child:Row(children:[_metric('Média',avg.round().toString()),_metric('Mínima','$min'),_metric('Máxima','$max'),_metric('Registros','${data.length}')])) ,
      const SizedBox(height:14),
      _Card(title:'Evolução da glicemia',child:_MiniChart(records:data)),
      const SizedBox(height:14),
      SizedBox(height:52,child:ElevatedButton.icon(onPressed:data.isEmpty?null:()=>ReportService.printReport(start:start??data.first.dateTime,end:end??data.last.dateTime,records:data),icon:const Icon(Icons.picture_as_pdf_outlined),label:const Text('GERAR RELATÓRIO COMPLETO',style:TextStyle(fontWeight:FontWeight.w800)),style:ElevatedButton.styleFrom(backgroundColor:AppColors.brand,foregroundColor:Colors.white,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(16))))),
      const SizedBox(height:8), Center(child:Text('${data.length} medição(ões) no período selecionado.',style:const TextStyle(color:AppColors.muted,fontSize:12))),
    ];
  }));
  Widget _dateButton(String label,DateTime? value,Future<void> Function(bool) pick,bool isStart)=>OutlinedButton(onPressed:()=>pick(isStart),style:OutlinedButton.styleFrom(padding:const EdgeInsets.symmetric(horizontal:12,vertical:13),side:const BorderSide(color:AppColors.line),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14))),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(label,style:const TextStyle(fontSize:11,color:AppColors.muted)),const SizedBox(height:4),Text(value==null?'Selecionar':_fmt(value),style:const TextStyle(fontWeight:FontWeight.w800,color:AppColors.brandDeep))]));
  Widget _quickButton(String label,int days)=>OutlinedButton(onPressed:()=>_quick(days),child:Text(label));
  Widget _metric(String l,String v)=>Expanded(child:Column(children:[Text(l,style:const TextStyle(fontSize:11,color:AppColors.muted,fontWeight:FontWeight.w700)),const SizedBox(height:4),Text(v,style:const TextStyle(fontSize:19,color:AppColors.brandDeep,fontWeight:FontWeight.w800))]));
}
class _Card extends StatelessWidget{final String title;final Widget child;const _Card({required this.title,required this.child});@override Widget build(BuildContext c)=>Container(padding:const EdgeInsets.all(16),decoration:BoxDecoration(color:AppColors.surface,border:Border.all(color:AppColors.line),borderRadius:BorderRadius.circular(20)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontSize:17,fontWeight:FontWeight.w800,color:AppColors.brandDeep)),const SizedBox(height:12),child]));}
class _MiniChart extends StatelessWidget{final List<GlycemiaRecord> records;const _MiniChart({required this.records});@override Widget build(BuildContext c){if(records.isEmpty)return const SizedBox(height:120,child:Center(child:Text('Nenhuma medição no período.',style:TextStyle(color:AppColors.muted)))); final max=records.map((r)=>r.glycemia).reduce((a,b)=>a>b?a:b).toDouble();final min=records.map((r)=>r.glycemia).reduce((a,b)=>a<b?a:b).toDouble();return SizedBox(height:180,child:CustomPaint(painter:_P(records,min,max)));}}
class _P extends CustomPainter{final List<GlycemiaRecord> r;final double min,max;_P(this.r,this.min,this.max);@override void paint(Canvas c,Size s){final left=30.0,right=8.0,top=10.0,bottom=12.0;final w=s.width-left-right,h=s.height-top-bottom;final range=(max-min).abs()<1?1:max-min;final line=Paint()..color=AppColors.accent..strokeWidth=2.5..style=PaintingStyle.stroke..strokeCap=StrokeCap.round;final dot=Paint()..color=AppColors.accent;for(int i=0;i<r.length;i++){final x=left+(r.length==1?w/2:i*w/(r.length-1));final y=top+(1-(r[i].glycemia-min)/range)*h;if(i>0){final px=left+(i-1)*w/(r.length-1);final py=top+(1-(r[i-1].glycemia-min)/range)*h;c.drawLine(Offset(px,py),Offset(x,y),line);}c.drawCircle(Offset(x,y),3.5,dot);}}@override bool shouldRepaint(covariant _P o)=>o.r!=r;}
