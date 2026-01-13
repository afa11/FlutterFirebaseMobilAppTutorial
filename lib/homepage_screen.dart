import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  // Maç skorları
  Map<String, Map<String, int>> matchScores = {
    'İspanya - Almanya': {'home': 0, 'away': 0},
    'Fransa - İngiltere': {'home': 0, 'away': 0},
    'Brezilya - Arjantin': {'home': 0, 'away': 0},
    'Portekiz - Hollanda': {'home': 0, 'away': 0},
  };

  // Leaderboard verileri (örnek)
  List<Map<String, dynamic>> leaderboard = [
    {'name': 'Ahmet Y.', 'points': 245},
    {'name': 'Mehmet K.', 'points': 238},
    {'name': 'Ayşe D.', 'points': 225},
    {'name': 'Fatma S.', 'points': 210},
    {'name': 'Ali T.', 'points': 195},
  ];

  void updateScore(String match, String team, bool increment) {
    setState(() {
      if (increment) {
        matchScores[match]![team] = matchScores[match]![team]! + 1;
      } else {
        if (matchScores[match]![team]! > 0) {
          matchScores[match]![team] = matchScores[match]![team]! - 1;
        }
      }
    });
  }

  void submitScores() {
    // Burada skorları Firebase'e kaydedeceksiniz
    Get.snackbar(
      'Başarılı',
      'Skorlar kaydedildi!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/login_bg.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment(-0.3, 0),
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: SafeArea(
            child: Column(
              children: [
                // Başlık
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade800,
                              Colors.green.shade900,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black, width: 3),
                        ),
                        child: const Text(
                          'Günün Maçları',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 5,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // İçerik (Scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Maçlar Listesi
                        ...matchScores.entries.map((entry) {
                          final matchName = entry.key;
                          final teams = matchName.split(' - ');
                          final homeScore = entry.value['home']!;
                          final awayScore = entry.value['away']!;

                          return _buildMatchCard(
                            homeTeam: teams[0],
                            awayTeam: teams[1],
                            homeScore: homeScore,
                            awayScore: awayScore,
                            matchKey: matchName,
                          );
                        }).toList(),

                        const SizedBox(height: 16),

                        // Submit Butonu
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.green.shade700.withOpacity(0.8),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                        color: Colors.black, width: 3),
                                  ),
                                ),
                                onPressed: submitScores,
                                child: const Text(
                                  'Skorları Kaydet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Leaderboard
                        _buildLeaderboard(),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchCard({
    required String homeTeam,
    required String awayTeam,
    required int homeScore,
    required int awayScore,
    required String matchKey,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black, width: 3),
            ),
            child: Column(
              children: [
                // Ev Sahibi Takım
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        homeTeam,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    _buildCounter(
                      value: homeScore,
                      onIncrement: () => updateScore(matchKey, 'home', true),
                      onDecrement: () => updateScore(matchKey, 'home', false),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Deplasman Takımı
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        awayTeam,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    _buildCounter(
                      value: awayScore,
                      onIncrement: () => updateScore(matchKey, 'away', true),
                      onDecrement: () => updateScore(matchKey, 'away', false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounter({
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Row(
      children: [
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.remove_circle, color: Colors.red, size: 30),
        ),
        Container(
          width: 50,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.add_circle, color: Colors.green, size: 30),
        ),
      ],
    );
  }

  Widget _buildLeaderboard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: Column(
            children: [
              const Text(
                '🏆 Liderlik Tablosu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...leaderboard.asMap().entries.map((entry) {
                final index = entry.key;
                final player = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: index == 0
                            ? Colors.yellow
                            : Colors.white.withOpacity(0.3),
                        width: index == 0 ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${index + 1}.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: index == 0 ? Colors.yellow : Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            player['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          '${player['points']} puan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
