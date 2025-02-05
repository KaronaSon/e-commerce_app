import 'package:ecommerc_app/data/about_data.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50, bottom: 30),
            child: Center(
              child: Text(
                'Developer',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              var item = aboutData[index];
              return Card(
                color: Colors.grey.shade300,
                elevation: 10,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                          item.image,
                        ),
                      ),
                    ),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: aboutData.length,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Text(
                    'A developer, computer programmer or coder is an author of computer source code-someone with skill in computer programming.Being a software developer means solving problems, and applying the solution using code. They design and write the code used to build everything from operating systems to mobile apps to video.A developer is a technology professional who works on, builds and creates software, websites, applications and other systems. Often, developers require a knowledge of coding to write and debug source code for applications and software effectively.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
