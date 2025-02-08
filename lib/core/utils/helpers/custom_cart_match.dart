import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'theme.dart';

class MatchCard extends StatelessWidget {
  final String team1Name;
  final String team1LogoPath;
  final String team1Score;
  final String team2Name;
  final String team2LogoPath;
  final String team2Score;
  final String matchTime;
  final String matchDate;

  MatchCard({
    required this.team1Name,
    required this.team1LogoPath,
    required this.team1Score,
    required this.team2Name,
    required this.team2LogoPath,
    required this.team2Score,
    required this.matchTime,
    required this.matchDate,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Container(
            height: 218.h,
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              border: Border.all(
                color: StylesApp.instance.mainColor,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 15.0),
                const Text(
                  'دورة الزعيم الاولى',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TeamInfo(
                      teamName: team1Name,
                      logoPath: team1LogoPath,
                      score: team1Score,
                    ),
                    const Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TeamInfo(
                      teamName: team2Name,
                      logoPath: team2LogoPath,
                      score: team2Score,
                    ),
                  ],
                ),

                const Text(
                  'انتهت',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.red),
                        const SizedBox(width: 4.0),
                        Text(matchTime),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.red),
                        const SizedBox(width: 4.0),
                        Text(matchDate),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -20,
          left: 34,
          child: Image.network(
            team1LogoPath,
            height: 50,
            width: 50,
          ),
        ),
        Positioned(
          top: -20,
          right: 34,
          child: Image.network(
            team2LogoPath,
            height: 50,
            width: 50,
          ),
        ),
      ],
    );
  }
}

class TeamInfo extends StatelessWidget {
  final String teamName;
  final String logoPath;
  final String score;

  TeamInfo(
      {required this.teamName, required this.logoPath, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 22),
        Text(
          teamName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            score,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
