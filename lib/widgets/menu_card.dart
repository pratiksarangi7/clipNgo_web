import 'package:clipngo_web/providers/page_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuCard extends ConsumerStatefulWidget {
  const MenuCard({
    super.key,
    required this.content,
    required this.contentIcon,
    required this.onClicked,
    required this.itemIndex,
  });
  final String content;
  final IconData contentIcon;
  final Function onClicked;
  final int itemIndex;

  @override
  ConsumerState<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends ConsumerState<MenuCard> {
  bool isHovered = false;
  void _onEnter(PointerEvent event) {
    setState(() {
      isHovered = true;
    });
  }

  void _onExit(PointerEvent event) {
    setState(() {
      isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int selectedMenuCard = ref.watch(partScreenIndexProvider);
    bool isClicked = (selectedMenuCard == widget.itemIndex);
    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      child: InkWell(
        onTap: () => widget.onClicked(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isClicked
                ? Theme.of(context).colorScheme.primary
                : Colors.white,
          ),
          padding: const EdgeInsets.all(8),
          child: Row(children: [
            Icon(
              widget.contentIcon,
              color: isClicked
                  ? Theme.of(context).colorScheme.onPrimary
                  : isHovered
                      ? Theme.of(context).colorScheme.primary
                      : const Color.fromARGB(255, 129, 129, 129),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(widget.content,
                style: TextStyle(
                    color: isClicked
                        ? Theme.of(context).colorScheme.onPrimary
                        : isHovered
                            ? Theme.of(context).colorScheme.primary
                            : const Color.fromARGB(255, 129, 129, 129))),
          ]),
        ),
      ),
    );
  }
}
