import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class LessonDetailScreen extends StatefulWidget {
  final String characterName;
  final String audioUrl;
  final String lessonText;

  const LessonDetailScreen({
    super.key,
    required this.characterName,
    required this.audioUrl,
    required this.lessonText,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  // --- Плеер для задания ---
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isAudioPlaying = false;

  // --- Рекордер для записи ответа ---
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  String? _recordedAudioPath;
  bool _micPermissionGranted = false;

  // --- Плеер для прослушивания своего ответа ---
  final AudioPlayer _myAudioPlayer = AudioPlayer();
  bool _isMyAudioPlaying = false;
  Duration _myCurrentPosition = Duration.zero;
  Duration _myTotalDuration = Duration.zero;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  // Состояние урока
  String? userTextResponse;
  String? userAudioResponse;
  bool hasUserResponded = false;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();

    // Автофокус на поле ввода при открытии урока
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textFocusNode.requestFocus();
    });

    // Отслеживаем изменения фокуса
    _textFocusNode.addListener(() {
      setState(() {
        _isKeyboardVisible = _textFocusNode.hasFocus;
      });
    });

    // --- Задание: слушаем позицию и длительность ---
    _audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        _currentPosition = p;
      });
    });
    _audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _totalDuration = d;
      });
    });
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isAudioPlaying = false;
        _currentPosition = Duration.zero;
      });
    });

    // --- Мой ответ: слушаем позицию и длительность ---
    _myAudioPlayer.onPositionChanged.listen((p) {
      setState(() {
        _myCurrentPosition = p;
      });
    });
    _myAudioPlayer.onDurationChanged.listen((d) {
      setState(() {
        _myTotalDuration = d;
      });
    });
    _myAudioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isMyAudioPlaying = false;
        _myCurrentPosition = Duration.zero;
      });
    });

    // --- Инициализируем рекордер ---
    _initRecorder();
    _requestMicrophonePermission();
  }

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    setState(() {
      _micPermissionGranted = status.isGranted;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _myAudioPlayer.dispose();
    _recorder.closeRecorder();
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  // --- Плеер для задания ---
  void _togglePlayPause() async {
    if (_isAudioPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
    setState(() {
      _isAudioPlaying = !_isAudioPlaying;
    });
  }

  void _seekAudio(double value) {
    if (_totalDuration.inMilliseconds > 0) {
      final position = _totalDuration * value;
      _audioPlayer.seek(position);
    }
  }

  // --- Рекордер для ответа ---
  Future<void> _startRecording() async {
    if (!_micPermissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Нет доступа к микрофону!')),
      );
      return;
    }

    final tempDir = Directory.systemTemp.path;
    final filePath = '$tempDir/lesson_response_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.startRecorder(toFile: filePath);
    setState(() {
      _isRecording = true;
      _recordedAudioPath = filePath;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
      userAudioResponse = _recordedAudioPath;
      hasUserResponded = true;
      _isKeyboardVisible = false;
    });
    _textFocusNode.unfocus();
  }

  void _sendTextMessage() {
    if (_textController.text.trim().isNotEmpty) {
      setState(() {
        userTextResponse = _textController.text.trim();
        hasUserResponded = true;
        _isKeyboardVisible = false;
      });
      _textFocusNode.unfocus();
    }
  }

  void _resetLesson() {
    setState(() {
      userTextResponse = null;
      userAudioResponse = null;
      hasUserResponded = false;
      _textController.clear();
      _isKeyboardVisible = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textFocusNode.requestFocus();
    });
  }

  void _finishLesson() {
    Navigator.pop(context);
  }

  void _togglePlayPauseMyAudio() async {
    if (userAudioResponse == null) return;
    if (_isMyAudioPlaying) {
      await _myAudioPlayer.pause();
    } else {
      await _myAudioPlayer.play(DeviceFileSource(userAudioResponse!));
    }
    setState(() {
      _isMyAudioPlaying = !_isMyAudioPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double progress = _totalDuration.inMilliseconds > 0
        ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
        : 0.0;

    final double bottomPadding = _isKeyboardVisible ? 16 : 48 + 16;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.characterName,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildLessonHeader(progress),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildCharacterMessage(),
                    const SizedBox(height: 24),
                    if (hasUserResponded) ...[
                      _buildUserResponses(),
                      const SizedBox(height: 80),
                    ],
                    if (!hasUserResponded) const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: Colors.grey[50],
        padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPadding),
        child: hasUserResponded
            ? _buildActionButtons()
            : _buildInputArea(),
      ),
    );
  }

  Widget _buildLessonHeader(double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://randomuser.me/api/portraits/men/1.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ashley Young",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Material(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(24),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: _togglePlayPause,
                        child: Container(
                          width: 48,
                          height: 48,
                          child: Icon(
                            _isAudioPlaying ? Icons.pause : Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAudioWaveform(progress),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioWaveform(double progress) {
    return Container(
      height: 32, // уменьшили высоту контейнера
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1), // серая рамка
        borderRadius: BorderRadius.circular(16), // скругление углов
        color: Colors.white, // белый фон
      ),
      child: GestureDetector(
        onTapDown: (details) {
          final RenderBox? box = context.findRenderObject() as RenderBox?;
          if (box != null) {
            final localPosition = box.globalToLocal(details.globalPosition);
            final width = box.size.width;
            final newProgress = (localPosition.dx / width).clamp(0.0, 1.0);
            _seekAudio(newProgress);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(20, (index) {
            final waveHeights = [
              0.4, 0.8, 0.5, 0.9, 0.3, 1.0, 0.6, 0.7, 0.9, 0.4,
              0.8, 0.5, 1.0, 0.3, 0.7, 0.9, 0.4, 0.8, 0.6, 0.5,
              0.4, 0.8, 0.5, 0.9, 0.3, 1.0, 0.6, 0.7, 0.9
            ];

            final waveHeight = waveHeights[index] * 18;
            final isPlayed = index / 20 <= progress;

            return Container(
              width: 2,
              height: waveHeight + 3,
              decoration: BoxDecoration(
                color: isPlayed ? Colors.blue[600] : Colors.grey[400],
                borderRadius: BorderRadius.circular(1),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCharacterMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey[300]!, width: 1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          'Поздоровайтесь с клиентом и предложите помощь. Используйте вежливые формы обращения и проявите заинтересованность в решении его проблемы.',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildUserResponses() {
    return Column(
      children: [
        if (userTextResponse != null) _buildTextResponse(),
        if (userAudioResponse != null) _buildAudioResponse(),
      ],
    );
  }

  Widget _buildTextResponse() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.only(bottom: 12, left: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          userTextResponse!,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildAudioResponse() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.only(bottom: 12, left: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: Colors.blue[600],
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _togglePlayPauseMyAudio,
                child: Container(
                  width: 40,
                  height: 40,
                  child: Icon(
                    _isMyAudioPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Голосовое сообщение',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.mic,
              color: Colors.blue[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Material(
          color: Colors.grey[600],
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _resetLesson,
            child: Container(
              width: 56,
              height: 56,
              child: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Material(
            color: Colors.green[600],
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _finishLesson,
              child: Container(
                height: 56,
                child: const Center(
                  child: Text(
                    'Finish and get result',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Material(
            color: _isRecording ? Colors.red[400] : Colors.grey[400],
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: _isRecording ? _stopRecording : _startRecording,
              child: Container(
                width: 36,
                height: 36,
                child: Icon(
                  _isRecording ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 96,
              ),
              child: Scrollbar(
                child: TextField(
                  controller: _textController,
                  focusNode: _textFocusNode,
                  decoration: const InputDecoration(
                    hintText: 'Напишите ваш ответ...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    isDense: true,
                  ),
                  maxLines: null,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  onSubmitted: null,
                  scrollPhysics: const BouncingScrollPhysics(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: Colors.blue[600],
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: _sendTextMessage,
              child: Container(
                width: 36,
                height: 36,
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}