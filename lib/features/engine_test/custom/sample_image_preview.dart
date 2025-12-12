import 'package:flutter/material.dart';
import 'package:pg1/core/shared/extensions/num_extension.dart';

class SampleImagePreview extends StatelessWidget {
  final String title;
  final String url;
  final String csvContent;

  const SampleImagePreview({
    super.key,
    required this.title,
    required this.url,
    required this.csvContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InteractiveViewer(
                panEnabled: true,
                minScale: 1,
                maxScale: 4,
                child: Image.asset(
                  url,
                  width: double.infinity,
                ),
              ),
              10.heightGap,
              SizedBox(
                width: double.infinity,
                child: Card(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectableText(csvContent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
