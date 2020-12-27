import 'package:car_data_app/src/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 10),
          child: Center(
            child: Text(
              Utils.appName,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            var url = Utils.appRepoUrl;
            if (await canLaunch(url)) {
              await launch(url);
            }
            else {
              throw "Could not launch $url";
            }
          },
          child: Container(
            margin: EdgeInsets.only(top: 20, bottom: 20),
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(Utils.creatorIconPath),
                  fit: BoxFit.contain
              ),
            ),
          ),
        ),
        _addText("Designed and Created by Vidhyasagar Harihara"),
        _addText("Developed using Flutter SDK for Android and iOS"),
        _addText("November-December 2020"),
        Container(
          margin: EdgeInsets.only(top: 15, bottom: 15),
          height: 50,
          child: Row(
            children: [
              Expanded(child: Container()),
              Expanded(child: _linkButtons(Utils.githubUrl, Utils.githubIconPath)),
              Expanded(child: _linkButtons(Utils.linkedInUrl, Utils.linkedInIconPath)),
              Expanded(child: Container()),
            ],
          ),
        ),
        _addTextLink(Utils.serverUrl, "Powered by Phoenix/Elixir based server"),
        _addTextLink(Utils.datasetUrl, "Data sourced from the US Govt"),
        _addTextLink(Utils.dataPipelineUrl, "Dataset ingested using custom pipeline"),
      ],
    );
  }

  Widget _linkButtons(String url, String assetPath) =>
      GestureDetector(
        onTap: () async {
          if (await canLaunch(url)) {
            await launch(url);
          }
          else {
            throw "Could not launch $url";
          }
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage(assetPath),
                fit: BoxFit.fitHeight
            ),
          ),
        ),
      );

  Widget _addText(String text) =>
      Container(
        margin: EdgeInsets.only(top: 15, bottom: 15),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 15
            ),
          ),
        ),
      );

  Widget _addTextLink(String url, String displayText) =>
    InkWell(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        }
        else {
          throw "Could not launch $url";
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Center(
          child: Text(
            displayText,
            style: TextStyle(
                color: Colors.teal
            ),
          ),
        ),
      ),
    );
}