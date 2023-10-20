import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RadioPage extends ConsumerStatefulWidget {
  const RadioPage({super.key});

  @override
  ConsumerState<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends ConsumerState<RadioPage> {
  @override
  Widget build(BuildContext context) {
    bool radio = ref.watch(radioProvider.notifier).state;
    print(radio);
    return Scaffold(
      appBar: AppBar(
        title: Text('Radio Buttons'),
      ),
      body: Center(
        child: Column(
          children: [
            RadioListTile(
              value: true,
              groupValue: radio,
              onChanged: (value) {
                print(!radio);
                setState(() {
                  ref.watch(radioProvider.notifier).state = value!;
                });
              },
            ),
            SomeOtherWidget(),
          ],
        ),
      ),
    );
  }
}

class SomeOtherWidget extends ConsumerStatefulWidget {
  const SomeOtherWidget({super.key});

  @override
  ConsumerState<SomeOtherWidget> createState() => _SomeOtherWidgetState();
}

class _SomeOtherWidgetState extends ConsumerState<SomeOtherWidget> {
  @override
  Widget build(BuildContext context) {
    bool radio = ref.watch(radioProvider.notifier).state;
    print(radio);
    return SizedBox(
      child: RadioListTile(
        value: false,
        groupValue: radio,
        onChanged: (value) {
          print(value);
          setState(() {
            ref.watch(radioProvider.notifier).state = value!;
          });
        },
      ),
    );
  }
}

final radioProvider = StateProvider((ref) => true);

final tasksDone = Provider<int>((ref) {
  return 1;
});
