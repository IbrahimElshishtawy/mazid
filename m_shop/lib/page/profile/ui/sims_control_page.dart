import 'package:flutter/material.dart';

class SimsControlPage extends StatefulWidget {
  const SimsControlPage({super.key});

  @override
  State<SimsControlPage> createState() => _SimsControlPageState();
}

class _SimsControlPageState extends State<SimsControlPage> {
  bool _enableFeatureA = true;
  bool _enableFeatureB = false;
  double _simulationSpeed = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Sims Control Section", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "System Simulation & Features",
              style: TextStyle(color: Colors.orangeAccent, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text("Real-time Auction Updates", style: TextStyle(color: Colors.white)),
              value: _enableFeatureA,
              onChanged: (val) => setState(() => _enableFeatureA = val),
              activeColor: Colors.orangeAccent,
            ),
            SwitchListTile(
              title: const Text("Experimental UI Elements", style: TextStyle(color: Colors.white)),
              value: _enableFeatureB,
              onChanged: (val) => setState(() => _enableFeatureB = val),
              activeColor: Colors.orangeAccent,
            ),
            const SizedBox(height: 20),
            const Text(
              "Animation Speed",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Slider(
              value: _simulationSpeed,
              min: 0.5,
              max: 2.0,
              divisions: 3,
              label: _simulationSpeed.toString(),
              onChanged: (val) => setState(() => _simulationSpeed = val),
              activeColor: Colors.orangeAccent,
            ),
          ],
        ),
      ),
    );
  }
}
