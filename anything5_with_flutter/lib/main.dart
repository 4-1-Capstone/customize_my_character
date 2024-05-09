import 'dart:convert';
import 'package:anything5_with_flutter/output.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(CharacterSelectionApp());
}

class CharacterSelectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Character Selection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CharacterSelectionScreen(),
    );
  }
}

class CharacterSelectionScreen extends StatefulWidget {
  @override
  _CharacterSelectionScreenState createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  String selectedMovie = '';
  String gender = '';
  String hairStyle = '';
  String hasGlasses = '';
  String fashion = '';
  bool isLoading = false;
  List<String> imageUrls = [];
  String toggleButton1 = '';
  String toggleButton2 = '';
  String toggleButton3 = '';
  String toggleButton4 = '';
  String toggleButton5 = '';
  
  

  Future<void> sendRequest() async {
    setState(() {
      isLoading = true;
    });

    final updateResponse = await http.post(
      Uri.parse('http://127.0.0.1:5000/update-prompt'),
      body: {
        'selectedMovie': selectedMovie,
        'gender': gender,
        'hairStyle': hairStyle,
        'hasGlasses': hasGlasses,
        'fashion': fashion,
      },
    );

    if (updateResponse.statusCode == 200) {
      print('Prompt 업데이트 성공!');
      final generateResponse = await http.get(
        Uri.parse('http://127.0.0.1:5000/generate-image'),
      );

      if (generateResponse.statusCode == 200) {
        print('이미지 생성 성공!');
        final jsonResponse = json.decode(generateResponse.body);
        final List<dynamic> output = jsonResponse['output'];
        final List<String> urls = output.map((url) => url as String).toList();
        setState(() {
          imageUrls = urls;
          isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageDisplayScreen(imageUrls: imageUrls,),
          ),
        );
      } else {
        print('이미지 생성 실패: ${generateResponse.statusCode}');
      }
    } else {
      print('오류: ${updateResponse.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('캐릭터 특징 선택'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading ? Center(child: CircularProgressIndicator()) :
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('영화 선택'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              toggleButton('너의 이름은', toggleButton1, () {
                    setState(() {
                      toggleButton1 = "너의 이름은";
                      selectedMovie = 'shinkai makoto, kimi no na wa';
                      toggleButton2='';
                      toggleButton3='';
                      toggleButton4='';
                      toggleButton5 = '';
                    });
                  }),
            toggleButton('센과 치히로의 행방불명', toggleButton1, () {
                    setState(() {
                      toggleButton1 = "센과 치히로의 행방불명";
                      selectedMovie = 'Ghibli, Sen and Chihiro';
                      toggleButton2='';
                      toggleButton3='';
                      toggleButton4='';
                      toggleButton5 = '';
                    });
                  }),
            ],
            ),
            if (selectedMovie.isNotEmpty)
              Column(
                children: [
                  SizedBox(height: 10.0),
                  Text('성별 선택'),
                  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               if (selectedMovie == 'shinkai makoto, kimi no na wa') ...[
                      toggleButton('남자', toggleButton2, () {
                    setState(() {
                      toggleButton2 = "남자";
                      gender = 'tachibana taki, 1boy, male, no female body, little muscle, blue eyes, brown hair, ';
                    });
                  }),
                      toggleButton('여자', toggleButton2, () {
                    setState(() {
                      toggleButton2 = "여자";
                      gender = '1girl';
                    });
                  }),
                    ] else ...[
                      toggleButton('남자(하쿠)', toggleButton2, () {
                    setState(() {
                      toggleButton2 = "남자";
                      gender = 'haku, 1boy, male, thin,, barefoot';
                    });
                  }),
                      toggleButton('여자(치히로)', toggleButton2, () {
                    setState(() {
                      toggleButton2 = "여자";
                      gender = 'ogino chihiro, 1girl';
                    });
                  }),
                      ], 
              
            
            ],
            ),
                  SizedBox(height: 10.0),
                  Text('머리스타일 선택'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (selectedMovie == 'Ghibli, Sen and Chihiro') ...[
                      toggleButton('긴 머리', toggleButton3, () {
                      setState(() {
                        toggleButton3 = "긴 머리";
                        hairStyle = 'ponytail';
                      });
                    }),
                    toggleButton('짧은 머리', toggleButton3, () {
                      setState(() {
                        toggleButton3 = "짧은 머리";
                        hairStyle = 'bob cut Hair, black hair, chin-length black hair, serious expression';
                      });
                    })
                    ] else ...[
                      toggleButton('긴 머리', toggleButton3, () {
                      setState(() {
                        toggleButton3 = "긴 머리";
                        hairStyle = 'brown eyes, long hair, brown hair, black hair';
                      });
                    }),
                    toggleButton('짧은 머리', toggleButton3, () {
                      setState(() {
                        toggleButton3 = "짧은 머리";
                        hairStyle = 'short hair';
                      });
                    })
                    ]
                    ],
                  ),
                  
                  SizedBox(height: 10.0),
                  Text('안경 유무 선택'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    toggleButton('있음', toggleButton4, () {
                      setState(() {
                        toggleButton4 = "있음";
                        hasGlasses = 'glasses';
                      });
                    }),
                    toggleButton('없음', toggleButton4, () {
                      setState(() {
                        toggleButton4 = "없음";
                        hasGlasses = 'no glasses';
                      });
                    }),
                  ],),
                  SizedBox(height: 10.0),
                  Text('패션 선택'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (selectedMovie == 'Ghibli, Sen and Chihiro') ...[
                      toggleButton('여성용 의복', toggleButton5, () {
                        setState(() {
                          toggleButton5 = "여성용 의복";
                          fashion = 'yunaifomu, long arm shirt, half pants, red clothes, barefoot,attached a red string to waist';
                        });
                      }),
                      toggleButton('남성용 의복', toggleButton5, () {
                        setState(() {
                          toggleButton5 = "남성용 의복";
                          fashion = 'traditional and modest,unembellished tunic, soft grey color clothes, loosely fitted, mid-thigh length,clean-cut neckline,slightly draped sleeves, waist with a soft purple sash';
                        });
                      }),
                    ] else ...[
                      toggleButton('여성교복',toggleButton5, () {
                        setState(() {
                          toggleButton5 = "여성교복";
                          fashion = ' bangs, blush, bow, bowtie, brown eyes, cloud, collared shirt, hair ribbon, hairband, looking at viewer, negative space, outdoors, red bow, red bowtie, red hairband, red ribbon, ribbon,  school uniform, shirt, sky, smile, solo, sweater vest, vest, white shirt, yellow sweater vest, yellow vest ';
                        });
                      }),
                      toggleButton('후드', toggleButton5, () {
                        setState(() {
                          toggleButton5 = "후드";
                          fashion = 'long pants, hood, hoodie, school uniform';
                        });
                      }),
                      ], 
                    ]   ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    ElevatedButton(
                    onPressed: () async {
                      await sendRequest();
                      
                    },
                    child: Text('확인'),
                  ),],)
              

                  ]
              ),
          ],
        ),
      ),
    );
  }
  Widget toggleButton(String text, String categoryValue, VoidCallback onPressed) {
  bool isSelected = categoryValue == text;
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: isSelected ? Colors.blue : Colors.grey,
    ),
    child: Text(text),
  );
}
}
