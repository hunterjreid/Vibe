import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({Key? key}) : super(key: key);

  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }


  @override
  Widget build(BuildContext context) {

      final size = MediaQuery.of(context).size;

    return Scaffold(

      body: PageView.builder(
          // itemCount: 1,
      controller: PageController(initialPage: 0, viewportFraction: 1),
      scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
        return Stack(
          children: [
           // VideoPlayerItem(videoUrl: ,),
            Column(
              children: [
                const SizedBox(height: 100,),
                Expanded(child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: Container(padding: const EdgeInsets.only(left: 20,),
                    child: Column(mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('username', style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold,),),
                      Text('caption', style: const TextStyle(fontSize: 15, color: Colors.white,),),
                      Row(children: [
                        const Icon(Icons.music_note, size: 15, color: Colors.white,),
                        Text('song name',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ))
                      ],)
                    ]
                    
                    
                    ),
                    
                    ),),
                  ],
                  
                )),
                  
              ],

            ),
               Container(
                  width: 100,
                  margin: EdgeInsets.only(top: size.height / 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildProfile("string url"),
                       Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.favorite,
                                        size: 40,
                                        color: 

                                            Colors.white
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      '0',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                      Column(
                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.comment,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      "0",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],


                      ),
                                      Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.reply,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                   '0',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                    ],
                  ),
                ),
           

          ],


        );
      },
    )
  );
  }
}