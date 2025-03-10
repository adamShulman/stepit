
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:stepit/classes/abstract_challenges/challenge.dart';
import 'package:stepit/classes/challenge_singleton.dart';
import 'package:stepit/utils/utils.dart';
import 'package:stepit/widgets/app_bar.dart';
import 'package:stepit/widgets/background_gradient_container.dart';
import 'package:stepit/widgets/challenge_button.dart';
import 'package:stepit/widgets/custom_borders.dart';
import 'package:stepit/widgets/flutter_map_widget.dart';

class ChallengePage extends StatefulWidget {

  final Challenge challenge;
  
  const ChallengePage({ super.key, required this.challenge });

  @override
  State<StatefulWidget> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {

  late void Function() childCallback;

  final _key = GlobalKey<ExpandableFabState>();

  bool get _isAnotherChallengeInProgress {
    return LazySingleton.instance.anotherChallengeInProgress(widget.challenge.id);
  }

  bool _toggleMap = true;

  bool get _canShowMap {
    return _isCurrentChallengeActive && _toggleMap;
  }

  bool get _isCurrentChallengeActive {
    Challenge? activeChallenge = LazySingleton.instance.activeChallenge;
    if (activeChallenge == null) { return false; }
    return activeChallenge.id == widget.challenge.id && widget.challenge.challengeStatus == ChallengeStatus.active;
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: const StepItAppBar(
        title: 'Overview',
      ),
      body: BackgroundGradientContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              // key: ValueKey(widget.challenge.id),
                
                tag: widget.challenge.id,
                child: ChallengeUtils.buildChallengeWidget(
                  widget.challenge, 
                  builder: (context, callbackFromChild) {
                    childCallback = callbackFromChild;
                  },
                ),
              ),

            _canShowMap 
            ? const Expanded(
              child: FlutterMapWidget(),
            )
            : const SizedBox.shrink(),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ChallengeButton(
                  text: _isAnotherChallengeInProgress
                    ? 'Another challenge in progress' 
                    : widget.challenge.challengeStatus.challengeButtonTitle,
                  icon: _isAnotherChallengeInProgress 
                    ? Icons.info
                    : ChallengeUtils.buttonIconDataFor(widget.challenge.challengeStatus),
                  shape: widget.challenge.challengeStatus == ChallengeStatus.active 
                  ? const CustomOutlinedBorder() 
                  : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  onPressed: () {
                    setState(() { 
                        childCallback.call();
                    });
                  }, 
                  
                ),
               
            ),
            
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: ValueListenableBuilder(
            //     valueListenable: widget.challenge.challengeStatusNotifier,
            //     builder: (context, value, child) {
            //       final buttonTitle = LazySingleton.instance.anotherChallengeInProgress(widget.challenge.id) 
            //         ? 'Another challenge in progress' 
            //         : value.challengeButtonTitle;

            //       // final icon = 
            //       return ChallengeButton(
            //         text: buttonTitle,
            //         isLoading: _isLoading,
            //         isCompleted: _isCompleted,
            //         icon: ChallengeUtils.buttonIconDataFor(value),
            //         shape: value == ChallengeStatus.active 
            //         ? const CustomOutlinedBorder() 
            //         : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            //         onPressed: () {
            //           setState(() { 
            //              childCallback.call();
            //           });
            //         }, 
                    
            //       );
                 
                
            //     },
            //   ),
            // ),
            
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: widget.challenge.challengeStatusNotifier,
        builder: (context, value, child) {
          switch (value) {

            case ChallengeStatus.active:
              return ExpandableFab(
        
                key: _key,
                type: ExpandableFabType.up,
                distance: 50,
                overlayStyle: ExpandableFabOverlayStyle(
                 color: Colors.black.withValues(alpha: 0.5),
                  blur: 2,
                ),
                openButtonBuilder: RotateFloatingActionButtonBuilder(
                  child: const Icon(Icons.menu),
                  fabSize: ExpandableFabSize.small,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                ),
                closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                  child: const Icon(Icons.close),
                  fabSize: ExpandableFabSize.small,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  shape: const CircleBorder(),
                ),
                onOpen: () {
                  debugPrint('onOpen');
                },
                afterOpen: () {
                  debugPrint('afterOpen');
                },
                onClose: () {
                  debugPrint('onClose');
                },
                afterClose: () {
                  debugPrint('afterClose');
                },
                children: [
                  // FloatingActionButton.small(
                  //   shape: const CircleBorder(),
                  //   heroTag: null,
                  //   child: const Icon(Icons.share),
                  //   onPressed: () {
                  //     final state = _key.currentState;
                  //     if (state != null) {
                  //       debugPrint('isOpen:${state.isOpen}');
                  //       state.toggle();
                  //     }
                  //   },
                  // ),
                  Row(
                    children: [
                      const Text(
                        'End challenge',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      FloatingActionButton.small(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        heroTag: null,
                        child: const Icon(Icons.stop),
                        onPressed: () {
                          final state = _key.currentState;
                          if (state != null) {
                            debugPrint('isOpen:${state.isOpen}');
                            state.toggle();
                          }
                        },
                      ),
                      
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Toggle map',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      FloatingActionButton.small(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        heroTag: null,
                        child: const Icon(Icons.map),
                        onPressed: () {
                          final state = _key.currentState;
                          if (state != null) {
                            debugPrint('isOpen:${state.isOpen}');
                            state.toggle();
                          }
                          setState(() {
                            _toggleMap = !_toggleMap;
                            // LazySingleton.instance.showMap = _toggleMap;
                          });
                          
                        },
                      ),
                    ],
                  )
                  
                ]
                // children: [
                //   FloatingActionButton.small(
                //     // shape: const CircleBorder(),
                //     heroTag: null,
                //     child: const Icon(Icons.edit),
                //     onPressed: () {
                //       const SnackBar snackBar = SnackBar(
                //         content: Text("SnackBar"),
                //       );
                      
                //       // scaffoldKey.currentState?.showSnackBar(snackBar);
                //     },
                //   ),
                //   FloatingActionButton.small(
                //     shape: const CircleBorder(),
                //     heroTag: null,
                //     child: const Icon(Icons.search),
                //     onPressed: () {
                //       // Navigator.of(context).push(
                //       //     MaterialPageRoute(builder: ((context) => const NextPage())));
                //     },
                //   ),
                  // FloatingActionButton.small(
                  //   shape: const CircleBorder(),
                  //   heroTag: null,
                  //   child: const Icon(Icons.share),
                  //   onPressed: () {
                  //     final state = _key.currentState;
                  //     if (state != null) {
                  //       debugPrint('isOpen:${state.isOpen}');
                  //       state.toggle();
                  //     }
                  //   },
                  // ),
                // ],
              );
            default:
              return const SizedBox.shrink();
          }
        },
      )
    );
  }
}

