import 'package:botnoi_voice_application/widgets/category_voice.dart';
import 'package:botnoi_voice_application/widgets/decorations/gradient_border_painter.dart';
import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget{
  const CustomBottomSheet({super.key});
  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheet(); 
  
  
}

class _CustomBottomSheet extends State<CustomBottomSheet>{
  double volumeValue = 50;
  double speedValue = 50;
  double borderRadius = 1;
  final List<Color> gradientColors = [Color.fromARGB(255, 242, 124, 255),Color.fromARGB(255, 31, 195, 255)]; 
  @override
  Widget build(BuildContext context){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('เลือกเสียง',textAlign: TextAlign.start,)
            ),
            const CategoryVoice(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('ตั้งค่าเพิ่มเติม',textAlign: TextAlign.start,)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 70,
                    child: Text('ความดัง', style: TextStyle(color: Colors.black),)),
                  Expanded(
                    child: Slider(
                      value: volumeValue, 
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: volumeValue.round().toString(),
                      onChanged: (value)=> setState(()=>volumeValue =value),
                      ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text('${volumeValue.round()}db',))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 70,
                    child: Text('ความเร็ว', style: TextStyle(color: Colors.black),)),
                  Expanded(
                    child: Slider(
                      value: speedValue, 
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: speedValue.round().toString(),
                      onChanged: (value)=> setState(()=>speedValue =value),
                      ),
                  ),
                  SizedBox(
                    width: 50,
                    child: Text('${speedValue.round()} x',))
                ],
              ),
            ),
            const Divider(color: Colors.grey,height: 0.5,),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaint(
                  painter: GradientBorderPainter(
                    gradientColors: gradientColors,
                    borderRadius: borderRadius),
                  child: OutlinedButton(
                    onPressed: (){}, 
                      style: OutlinedButton.styleFrom(
                      minimumSize: const Size(50, 50),
                      side: BorderSide.none,
                      ),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                  },
                    child: const Text('ยกเลิก',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16),
                      ),
                  ),
                  ),
                ),
              
                const SizedBox(width: 20),
                
                ElevatedButton(
                  onPressed: (){}, 
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    
                    ),
                    
                    shadowColor: Colors.transparent
              ),
                child: const Text('บันทึก', style: TextStyle(fontSize: 16),),
                )
              ],
              
            )
          ],
        ),
      ),
    );
  }
}