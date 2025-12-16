import '../models/track_model.dart';

class TrackData {
  // 1. Deep Sleep (수면 유도)
  static final List<Track> sleepTracks = [
    Track(
      id: 'sleep_01',
      title: '스탠다드 자장가',
      description: '가장 표준적인 피아노 자장가',
      audioUrl: 'assets/sound/1_1.mp3',
      midiUrl: 'assets/sound/1_1.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      bpm: '60 BPM',
      technicalSpecs: {
        'Key': 'C Major',
        'Tempo': '60 BPM',  // Verified from MIDI
        'Harmony': 'Simple Chords I',
        'Instruments': 'Grand Piano / Sub Bass'
      },
      tags: ['All Dog', 'Sleep', 'Piano'],
      isPremium: false,
      duration: '5:17',
    ),
    Track(
      id: 'sleep_02',
      title: '따뜻한 오후',
      description: '먹먹하고 부드러운 소리',
      audioUrl: 'assets/sound/1_2.mp3',
      midiUrl: 'assets/sound/1_2.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      bpm: '60 BPM',
      technicalSpecs: {
        'Key': 'G Major',
        'Tempo': '60 BPM',  // Verified from MIDI
        'Harmony': 'Simple Chords I',
        'Instruments': 'Grand Piano (Softest) / Warm Pad'
      },
      tags: ['All Dog', 'Sleep', 'Felt Piano'],
      isPremium: false,
      duration: '5:23',
    ),
    Track(
      id: 'sleep_03',
      title: '깊은 밤의 꿈',
      description: '깊은 울림이 있는 꿈결 같은 곡',
      audioUrl: 'assets/sound/1_3.mp3',
      midiUrl: 'assets/sound/1_3.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      bpm: '55 BPM',
      technicalSpecs: {
        'Key': 'D Major',
        'Tempo': '55 BPM',  // Verified from MIDI
        'Harmony': 'Simple Chords IV',
        'Instruments': 'String Ensemble / Sub Bass'
      },
      tags: ['Large Dog', 'Sleep', 'Cinematic'],
      isPremium: true,
      duration: '5:22',
    ),
    Track(
      id: 'sleep_04',
      title: '엄마의 요람',
      description: '포근하게 감싸주는 요람의 노래',
      audioUrl: 'assets/sound/1_4.mp3',
      midiUrl: 'assets/sound/1_4.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      bpm: '60 BPM',
      technicalSpecs: {
        'Key': 'Eb Major',
        'Tempo': '60 BPM',  // Verified from MIDI
        'Harmony': 'Simple Chords I',
        'Instruments': 'String Ensemble / Warm Pad'
      },
      tags: ['Large Dog', 'Sleep', 'Waltz'],
      isPremium: true,
      duration: '5:28',
    ),
    Track(
      id: 'sleep_05',
      title: '깊은 울림',
      description: '마음을 차분하게 하는 깊은 울림',
      audioUrl: 'assets/sound/1_5.mp3',
      midiUrl: 'assets/sound/1_5.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      bpm: '65 BPM',
      technicalSpecs: {
        'Key': 'A Major',
        'Tempo': '65 BPM',  // Corrected from MIDI (was 70)
        'Harmony': 'Simple Chords I',
        'Instruments': 'Grand Piano / String Ensemble'
      },
      tags: ['Medium Dog', 'Sleep', 'Standard'],
      isPremium: true,
      duration: '5:28',
    ),
    Track(
      id: 'sleep_06',
      title: '포근한 왈츠',
      description: '부드럽게 흔들리는 왈츠 리듬',
      audioUrl: 'assets/sound/1_6.mp3',
      midiUrl: 'assets/sound/1_6.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      bpm: '65 BPM',
      technicalSpecs: {
        'Key': 'F Major',
        'Tempo': '65 BPM',  // Corrected from MIDI (was 70)
        'Harmony': 'Simple Chords II',
        'Instruments': 'Grand Piano / Upright Bass'
      },
      tags: ['Medium Dog', 'Sleep', 'Waltz'],
      isPremium: true,
      duration: '5:24',
    ),
    Track(
      id: 'sleep_07',
      title: '맑은 아침',
      description: '상쾌하고 맑은 아침의 소리',
      audioUrl: 'assets/sound/1_7.mp3',
      midiUrl: 'assets/sound/1_7.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      bpm: '80 BPM',
      technicalSpecs: {
        'Key': 'C Major',
        'Tempo': '80 BPM',  // Verified from MIDI
        'Harmony': 'Simple Chords I',
        'Instruments': 'Harp / Woodwinds'
      },
      tags: ['Small Dog', 'Sleep', 'Clear'],
      isPremium: true,
      duration: '5:25',
    ),
    Track(
      id: 'sleep_08',
      title: '사뿐한 왈츠',
      description: '가볍고 사뿐한 왈츠',
      audioUrl: 'assets/sound/1_8.mp3',
      midiUrl: 'assets/sound/1_8.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      bpm: '60 BPM',
      technicalSpecs: {
        'Key': 'Bb Major',
        'Tempo': '60 BPM',  // Corrected from MIDI (was 80)
        'Harmony': 'Simple Chords III',
        'Instruments': 'Celesta / Bassoon'
      },
      tags: ['Small Dog', 'Sleep', 'Orgel'],
      isPremium: true,
      duration: '5:21',
    ),
  ];

  // 2. Calm Shelter (분리불안)
  static final List<Track> separationTracks = [
    Track(
      id: 'separation_01',
      title: '묵직한 위로',
      description: '첼로의 묵직한 저음이 주는 위로',
      audioUrl: 'assets/sound/2_1.mp3',
      midiUrl: 'assets/sound/2_1.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      bpm: '55 BPM',
      technicalSpecs: {
        'Key': 'C Minor',
        'Tempo': '55 BPM',  // Corrected from MIDI (was 60)
        'Harmony': 'Simple Chords I',
        'Instruments': 'Cello / String Ensemble'
      },
      tags: ['All Dog', 'Separation', 'Cello'],
      isPremium: false,
      duration: '5:30',
    ),
    Track(
      id: 'separation_02',
      title: '따뜻한 공명',
      description: '공간을 채우는 따뜻한 공명',
      audioUrl: 'assets/sound/2_2.mp3',
      midiUrl: 'assets/sound/2_2.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      bpm: '55 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '55 BPM',  // Extracted from MIDI (was 'Slow')
        'Harmony': 'Simple Chords IV',
        'Instruments': 'Warm Pad / 808 Bass'
      },
      tags: ['All Dog', 'Separation', 'Ensemble'],
      isPremium: false,
      duration: '5:21',
    ),
    Track(
      id: 'separation_03',
      title: '균형 잡힌 안정',
      description: '비올라가 주는 균형 잡힌 안정감',
      audioUrl: 'assets/sound/2_3.mp3',
      midiUrl: 'assets/sound/2_3.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      bpm: '70 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '70 BPM',  // Verified from MIDI
        'Harmony': 'Simple Chords I',
        'Instruments': 'Viola / Sub Bass'
      },
      tags: ['Large Dog', 'Separation', 'Viola'],
      isPremium: true,
      duration: '5:22',
    ),
    Track(
      id: 'separation_04',
      title: '포근한 공기',
      description: '공기처럼 감싸는 포근함',
      audioUrl: 'assets/sound/2_4.mp3',
      midiUrl: 'assets/sound/2_4.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      bpm: '70 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '70 BPM',  // Extracted from MIDI (was 'Slow')
        'Harmony': 'Simple Chords I',
        'Instruments': 'Soft Pad / Drone Bass'
      },
      tags: ['Large Dog', 'Separation', 'Duet'],
      isPremium: true,
      duration: '5:35',
    ),
    Track(
      id: 'separation_05',
      title: '산뜻한 안정',
      description: '하프 선율의 산뜻한 안정',
      audioUrl: 'assets/sound/2_5.mp3',
      midiUrl: 'assets/sound/2_5.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      bpm: '80 BPM',
      technicalSpecs: {
        'Key': 'C Major',
        'Tempo': '80 BPM',  // Verified from MIDI
        'Harmony': 'Simple Chords III',
        'Instruments': 'Harp / String Ensemble'
      },
      tags: ['Medium Dog', 'Separation', 'Violin'],
      isPremium: true,
      duration: '5:25',
    ),
    Track(
      id: 'separation_06',
      title: '밝은 공기',
      description: '밝고 따뜻한 분위기의 곡',
      audioUrl: 'assets/sound/2_6.mp3',
      midiUrl: 'assets/sound/2_6.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      bpm: '75 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '75 BPM',  // Extracted from MIDI (was 'Slow')
        'Harmony': 'Intermediate Mixed Chords I',
        'Instruments': 'Bright Pad / 808 Bass'
      },
      tags: ['Medium Dog', 'Separation', 'Chamber'],
      isPremium: true,
      duration: '5:20',
    ),
    Track(
      id: 'separation_07',
      title: '평온한 오후',
      description: '기타 선율과 함께하는 평온한 오후',
      audioUrl: 'assets/sound/2_7.mp3',
      midiUrl: 'assets/sound/2_7.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      bpm: '65 BPM',
      technicalSpecs: {
        'Key': 'G Major',
        'Tempo': '65 BPM',  // Verified from MIDI
        'Harmony': 'Simple Chords II',
        'Instruments': 'Acoustic Guitar / Electric Bass'
      },
      tags: ['Small Dog', 'Separation', 'Chamber'],
      isPremium: true,
      duration: '5:22',
    ),
    Track(
      id: 'separation_08',
      title: '숲속의 쉼터',
      description: '숲속 쉼터 같은 편안한 피아노',
      audioUrl: 'assets/sound/2_8.mp3',
      midiUrl: 'assets/sound/2_8.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      bpm: '70 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '70 BPM',  // Corrected from MIDI (was 65)
        'Harmony': 'Simple Chords I',
        'Instruments': 'Grand Piano / Woodwinds'
      },
      tags: ['Small Dog', 'Separation', 'Chamber'],
      isPremium: true,
      duration: '5:21',
    ),
  ];

  // 3. Noise Masking (소음 차단)
  static final List<Track> noiseTracks = [
    Track(
      id: 'noise_01',
      title: '부드러운 장막',
      description: '외부 소음을 부드럽게 덮어주는 장막',
      audioUrl: 'assets/sound/3_1.mp3',
      midiUrl: 'assets/sound/3_1.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      bpm: '55 BPM',
      technicalSpecs: {
        'Key': 'N/A',
        'Tempo': '55 BPM',  // Corrected from MIDI (was 60)
        'Harmony': 'Simple Chords IV',
        'Instruments': 'Analog Pad / 808 Bass'
      },
      tags: ['All Dog', 'Noise', 'Brown Noise'],
      isPremium: false,
      duration: '5:29',
    ),
    Track(
      id: 'noise_02',
      title: '깊은 방패',
      description: '깊고 든든한 소리 방패',
      audioUrl: 'assets/sound/3_2.mp3',
      midiUrl: 'assets/sound/3_2.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      bpm: '60 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '60 BPM',  // Verified from MIDI
        'Harmony': 'Intermediate Mixed Chords I',
        'Instruments': 'Dark Pad / 808 Bass'
      },
      tags: ['All Dog', 'Noise', 'Pink Noise'],
      isPremium: false,
      duration: '5:18',
    ),
    Track(
      id: 'noise_03',
      title: '일상의 평온',
      description: '일상 속 평온함을 주는 소리',
      audioUrl: 'assets/sound/3_3.mp3',
      midiUrl: 'assets/sound/3_3.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      bpm: '55 BPM',
      technicalSpecs: {
        'Key': 'N/A',
        'Tempo': '55 BPM',  // Verified from MIDI
        'Harmony': 'Simple Chords I',
        'Instruments': 'Warm Pad / Simple Bass'
      },
      tags: ['Large Dog', 'Noise', 'White Noise'],
      isPremium: true,
      duration: '5:13',
    ),
    Track(
      id: 'noise_04',
      title: '든든한 방음벽',
      description: '소음을 막아주는 든든한 저음',
      audioUrl: 'assets/sound/3_4.mp3',
      midiUrl: 'assets/sound/3_4.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      bpm: '60 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '60 BPM',  // Verified from MIDI
        'Harmony': 'Simple Chords IV',
        'Instruments': 'Low Pad / Drone Bass'
      },
      tags: ['Large Dog', 'Noise', 'White Noise'],
      isPremium: true,
      duration: '5:18',
    ),
    Track(
      id: 'noise_05',
      title: '산뜻한 보호막',
      description: '가볍고 산뜻한 소리 보호막',
      audioUrl: 'assets/sound/3_5.mp3',
      midiUrl: 'assets/sound/3_5.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      bpm: '75 BPM',
      technicalSpecs: {
        'Key': 'N/A',
        'Tempo': '75 BPM',  // Corrected from MIDI (was 70)
        'Harmony': 'Simple Chords I',
        'Instruments': 'Atmosphere / Simple Bass'
      },
      tags: ['Medium Dog', 'Noise', 'White Noise'],
      isPremium: true,
      duration: '5:14',
    ),
    Track(
      id: 'noise_06',
      title: '포근한 담요',
      description: '담요처럼 포근하게 감싸는 소리',
      audioUrl: 'assets/sound/3_6.mp3',
      midiUrl: 'assets/sound/3_6.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      bpm: '65 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '65 BPM',  // Corrected from MIDI (was 70)
        'Harmony': 'Simple Chords I',
        'Instruments': 'String Ensemble / Cello'
      },
      tags: ['Medium Dog', 'Noise', 'White Noise'],
      isPremium: true,
      duration: '5:17',
    ),
    Track(
      id: 'noise_07',
      title: '우주 여행',
      description: '신비로운 우주 공간 같은 느낌',
      audioUrl: 'assets/sound/3_7.mp3',
      midiUrl: 'assets/sound/3_7.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      bpm: '75 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '75 BPM',  // Corrected from MIDI (was 80)
        'Harmony': 'Intermediate Mixed Chords II',
        'Instruments': 'Space Pad / Deep Bass'
      },
      tags: ['Small Dog', 'Noise', 'White Noise'],
      isPremium: true,
      duration: '5:20',
    ),
    Track(
      id: 'noise_08',
      title: '깊은 바다',
      description: '심해처럼 깊고 고요한 소리',
      audioUrl: 'assets/sound/3_8.mp3',
      midiUrl: 'assets/sound/3_8.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      bpm: '85 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '85 BPM',  // Corrected from MIDI (was 80)
        'Harmony': 'Simple Chords IV',
        'Instruments': 'Filter Pad / 808 Bass'
      },
      tags: ['Small Dog', 'Noise', 'White Noise'],
      isPremium: true,
      duration: '5:22',
    ),
  ];

  // 4. Energy Boost (활력 증진)
  static final List<Track> energyTracks = [
    Track(
      id: 'energy_01',
      title: '리드미컬 산책',
      description: '경쾌한 피아노와 베이스의 산책',
      audioUrl: 'assets/sound/4_1.mp3',
      midiUrl: 'assets/sound/4_1.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      bpm: '100 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '100 BPM',  // Corrected from MIDI (was 95)
        'Harmony': 'Advanced Jazz Chords',
        'Instruments': 'Grand Piano / Double Bass'
      },
      tags: ['All Dogs', 'Energy', 'Marimba'],
      isPremium: false,
      duration: '5:16',
    ),
    Track(
      id: 'energy_02',
      title: '활기찬 터그',
      description: '에너지 넘치는 기타 사운드',
      audioUrl: 'assets/sound/4_2.mp3',
      midiUrl: 'assets/sound/4_2.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      bpm: '110 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '110 BPM',  // Corrected from MIDI (was 105)
        'Harmony': 'Power Chords',
        'Instruments': 'Electric Guitar / Electric Bass'
      },
      tags: ['All Dogs', 'Energy', 'Piano'],
      isPremium: false,
      duration: '5:18',
    ),
    Track(
      id: 'energy_03',
      title: '경쾌한 총총',
      description: '가볍게 뛰어노는 듯한 피아노',
      audioUrl: 'assets/sound/4_3.mp3',
      midiUrl: 'assets/sound/4_3.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      bpm: '110 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '110 BPM',  // Corrected from MIDI (was 105)
        'Harmony': 'Simple Chords III',
        'Instruments': 'Grand Piano / Electric Bass'
      },
      tags: ['All Dogs', 'Energy', 'Guitar'],
      isPremium: true,
      duration: '5:23',
    ),
    Track(
      id: 'energy_04',
      title: '신나는 술래',
      description: '신디사이저의 펑키한 리듬',
      audioUrl: 'assets/sound/4_4.mp3',
      midiUrl: 'assets/sound/4_4.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      bpm: '115 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '115 BPM',  // Verified from MIDI
        'Harmony': '7th Chords II',
        'Instruments': 'Synth Lead / Synth Bass'
      },
      tags: ['All Dogs', 'Energy', 'Guitar'],
      isPremium: true,
      duration: '5:20',
    ),
    Track(
      id: 'energy_05',
      title: '사뿐한 총총',
      description: '어쿠스틱 기타의 경쾌한 발걸음',
      audioUrl: 'assets/sound/4_5.mp3',
      midiUrl: 'assets/sound/4_5.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      bpm: '115 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '115 BPM',  // Verified from MIDI
        'Harmony': 'Simple Chords III',
        'Instruments': 'Acoustic Guitar / Acoustic Bass'
      },
      tags: ['All Dogs', 'Energy', 'Guitar'],
      isPremium: true,
      duration: '5:15',
    ),
    Track(
      id: 'energy_06',
      title: '신나는 우다다',
      description: '글로켄슈필의 맑고 신나는 소리',
      audioUrl: 'assets/sound/4_6.mp3',
      midiUrl: 'assets/sound/4_6.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      bpm: '130 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '130 BPM',  // Corrected from MIDI (was 125)
        'Harmony': 'Simple Chords III',
        'Instruments': 'Glockenspiel / Electric Bass'
      },
      tags: ['All Dogs', 'Energy', 'Guitar'],
      isPremium: true,
      duration: '5:17',
    ),
    Track(
      id: 'energy_07',
      title: '피크닉',
      description: '소풍 가는 길의 설렘',
      audioUrl: 'assets/sound/4_7.mp3',
      midiUrl: 'assets/sound/4_7.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      bpm: '100 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '100 BPM',  // Verified from MIDI
        'Harmony': 'Simple Chords II',
        'Instruments': 'Acoustic Guitar / Electric Bass'
      },
      tags: ['All Dogs', 'Energy', 'Guitar'],
      isPremium: true,
      duration: '5:19',
    ),
    Track(
      id: 'energy_08',
      title: '댄스 타임',
      description: '80년대 디스코 스타일의 댄스곡',
      audioUrl: 'assets/sound/4_8.mp3',
      midiUrl: 'assets/sound/4_8.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      bpm: '115 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '115 BPM',  // Corrected from MIDI (was 110)
        'Harmony': '7th Chords II',
        'Instruments': 'Poly Synth / Funky Bass'
      },
      tags: ['All Dogs', 'Energy', 'Guitar'],
      isPremium: true,
      duration: '5:21',
    ),
  ];

  // 5. Senior Care (시니어 펫 케어)
  static final List<Track> seniorTracks = [
    Track(
      id: 'senior_01',
      title: '치유의 주파수',
      description: '따뜻한 패드 사운드의 치유',
      audioUrl: 'assets/sound/5_1.mp3',
      midiUrl: 'assets/sound/5_1.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      bpm: '65 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '65 BPM',  // Corrected from MIDI (was 60)
        'Harmony': 'Simple Chords I',
        'Instruments': 'Warm Pad / 808 Bass'
      },
      tags: ['All Dog', 'Senior', 'Vibration'],
      isPremium: false,
      duration: '5:23',
    ),
    Track(
      id: 'senior_02',
      title: '깊은 안정',
      description: '현악 앙상블의 깊은 안정감',
      audioUrl: 'assets/sound/5_2.mp3',
      midiUrl: 'assets/sound/5_2.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      bpm: '65 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '60 BPM',  // Verified from MIDI
        'Harmony': 'Simple Chords I',
        'Instruments': 'String Ensemble / Double Bass'
      },
      tags: ['All Dog', 'Senior', 'Vibration'],
      isPremium: false,
      duration: '5:25',
    ),
    Track(
      id: 'senior_03',
      title: '부드러운 공명',
      description: '부드럽게 울려 퍼지는 공명',
      audioUrl: 'assets/sound/5_3.mp3',
      midiUrl: 'assets/sound/5_3.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      bpm: '65 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '55 BPM',  // Verified from MIDI
        'Harmony': 'Simple Chords IV',
        'Instruments': 'Warm Pad / Drone Bass'
      },
      tags: ['Large Dog', 'Senior', 'Vibration'],
      isPremium: true,
      duration: '5:12',
    ),
    Track(
      id: 'senior_04',
      title: '편안한 휴식',
      description: '가장 부드러운 피아노 소리',
      audioUrl: 'assets/sound/5_4.mp3',
      midiUrl: 'assets/sound/5_4.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      bpm: '65 BPM',
      technicalSpecs: {
        'Key': 'G Major',
        'Tempo': '65 BPM',  // Corrected from MIDI (was 60)
        'Harmony': 'Simple Chords I',
        'Instruments': 'Grand Piano (Softest) / Acoustic Bass'
      },
      tags: ['Large Dog', 'Senior', 'Complex Vibration'],
      isPremium: true,
      duration: '5:24',
    ),
    Track(
      id: 'senior_05',
      title: '포근한 온기',
      description: '아날로그 패드의 포근한 온기',
      audioUrl: 'assets/sound/5_5.mp3',
      midiUrl: 'assets/sound/5_5.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      bpm: '65 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '75 BPM',  // Corrected from MIDI (was 70)
        'Harmony': 'Simple Chords I',
        'Instruments': 'Analog Pad / 808 Bass'
      },
      tags: ['Medium Dog', 'Senior', 'Complex Vibration'],
      isPremium: true,
      duration: '5:17',
    ),
    Track(
      id: 'senior_06',
      title: '산뜻한 평온',
      description: '하프와 현악의 조화',
      audioUrl: 'assets/sound/5_6.mp3',
      midiUrl: 'assets/sound/5_6.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      bpm: '65 BPM',
      technicalSpecs: {
        'Key': 'F Major',
        'Tempo': '75 BPM',  // Corrected from MIDI (was 70)
        'Harmony': 'Simple Chords I',
        'Instruments': 'Harp / String Ensemble'
      },
      tags: ['Medium Dog', 'Senior', 'Complex Vibration'],
      isPremium: true,
      duration: '5:20',
    ),
    Track(
      id: 'senior_07',
      title: '영혼의 안식',
      description: '콰이어와 오르간의 안식',
      audioUrl: 'assets/sound/5_7.mp3',
      midiUrl: 'assets/sound/5_7.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      bpm: '65 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '85 BPM',  // Corrected from MIDI (was 80)
        'Harmony': 'Simple Chords I',
        'Instruments': 'Choir / Organ'
      },
      tags: ['Small Dog', 'Senior', 'Complex Vibration'],
      isPremium: true,
      duration: '5:18',
    ),
    Track(
      id: 'senior_08',
      title: '자연의 품',
      description: '플루트 소리가 주는 자연의 느낌',
      audioUrl: 'assets/sound/5_8.mp3',
      midiUrl: 'assets/sound/5_8.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      bpm: '65 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '85 BPM',  // Corrected from MIDI (was 80)
        'Harmony': 'Simple Chords IV',
        'Instruments': 'Flute / Acoustic Bass'
      },
      tags: ['Small Dog', 'Senior', 'Complex Vibration'],
      isPremium: true,
      duration: '5:22',
    ),
  ];

  // 6. Cat Sleep (고양이 수면 유도)
  static final List<Track> catSleepTracks = [
    Track(
      id: 'cat_sleep_01',
      title: '편안한 리듬',
      description: 'Piano의 따뜻한 중간 템포',
      audioUrl: 'assets/sound/6_1_골골송 자장가/New Composition  255.mp3',
      midiUrl: 'assets/sound/6_1_골골송 자장가/New Composition  255 - Orchestrated.mid',
      coverUrl: 'assets/images/cat_sleep_cover.jpg',
      bpm: '115 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '115 BPM',
        'Harmony': 'Simple Chords II',
        'Instruments': 'Acoustic Grand Piano',
      },
      tags: ['All Cat', 'Sleep', 'Piano'],
      isPremium: false,
    ),
    Track(
      id: 'cat_sleep_02',
      title: '맑은 별빛',
      description: 'Celesta의 청명한 소리',
      audioUrl: 'assets/sound/6_2_꿈꾸는 젤리/New Composition  256.mp3',
      midiUrl: 'assets/sound/6_2_꿈꾸는 젤리/New Composition  256 - Orchestrated.mid',
      coverUrl: 'assets/images/cat_sleep_cover.jpg',
      bpm: '55 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '55 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Celesta / Bassoon',
      },
      tags: ['All Cat', 'Sleep', 'Celesta'],
      isPremium: false,
    ),
    Track(
      id: 'cat_sleep_03',
      title: '깊은 휴식',
      description: 'Harp와 저음의 깊은 안정',
      audioUrl: 'assets/sound/6_3_아기냥의 낮잠/New Composition  257.mp3',
      midiUrl: 'assets/sound/6_3_아기냥의 낮잠/New Composition  257 - Orchestrated.mid',
      coverUrl: 'assets/images/cat_sleep_cover.jpg',
      bpm: '45 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '45 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Orchestral Harp / Contrabass',
      },
      tags: ['Small Cat', 'Sleep', 'Harp'],
      isPremium: true,
    ),
    Track(
      id: 'cat_sleep_04',
      title: '고요한 밤',
      description: '단순한 피아노의 평온함',
      audioUrl: 'assets/sound/6_4_엄마의 품/New Composition  258.mp3',
      midiUrl: 'assets/sound/6_4_엄마의 품/New Composition  258 - Orchestrated.mid',
      coverUrl: 'assets/images/cat_sleep_cover.jpg',
      bpm: '45 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '45 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Acoustic Grand Piano',
      },
      tags: ['Medium Cat', 'Sleep', 'Piano'],
      isPremium: true,
    ),
    Track(
      id: 'cat_sleep_05',
      title: '은은한 달빛',
      description: 'Piano 솔로의 부드러움',
      audioUrl: 'assets/sound/6_5_깊은 밤의 우주/New Composition  259.mp3',
      midiUrl: 'assets/sound/6_5_깊은 밤의 우주/New Composition  259 - Orchestrated.mid',
      coverUrl: 'assets/images/cat_sleep_cover.jpg',
      bpm: '55 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '55 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Acoustic Grand Piano',
      },
      tags: ['Large Cat', 'Sleep', 'Piano'],
      isPremium: true,
    ),
    Track(
      id: 'cat_sleep_06',
      title: '포근한 꿈',
      description: '느린 템포의 피아노 선율',
      audioUrl: 'assets/sound/6_6_달빛 소나타/New Composition  260.mp3',
      midiUrl: 'assets/sound/6_6_달빛 소나타/New Composition  260 - Orchestrated.mid',
      coverUrl: 'assets/images/cat_sleep_cover.jpg',
      bpm: '50 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '50 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Acoustic Grand Piano',
      },
      tags: ['Medium Cat', 'Sleep', 'Piano'],
      isPremium: true,
    ),
    Track(
      id: 'cat_sleep_07',
      title: '따뜻한 쉼터',
      description: 'Piano의 포근한 울림',
      audioUrl: 'assets/sound/6_7_따뜻한 온돌/New Composition  261.mp3',
      midiUrl: 'assets/sound/6_7_따뜻한 온돌/New Composition  261 - Orchestrated.mid',
      coverUrl: 'assets/images/cat_sleep_cover.jpg',
      bpm: '50 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '50 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Acoustic Grand Piano',
      },
      tags: ['Small Cat', 'Sleep', 'Piano'],
      isPremium: true,
    ),
    Track(
      id: 'cat_sleep_08',
      title: '부드러운 울림',
      description: 'Vibraphone의 독특한 질감',
      audioUrl: 'assets/sound/6_8_치유의 단잠/New Composition  262.mp3',
      midiUrl: 'assets/sound/6_8_치유의 단잠/New Composition  262 - Orchestrated.mid',
      coverUrl: 'assets/images/cat_sleep_cover.jpg',
      bpm: '50 BPM',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '50 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Vibraphone / Acoustic Grand Piano',
      },
      tags: ['Large Cat', 'Sleep', 'Vibraphone'],
      isPremium: true,
    ),
  ];

  // 7. Cat Separation (고양이 분리불안) - 재구성된 제목
  static final List<Track> catSeparationTracks = [
    Track(id: 'cat_separation_01', title: '안전한 공간', description: 'Orchestral Harp의 중간 템포', audioUrl: 'assets/sound/7_1_안전 가옥/New Composition  263.mp3', midiUrl: 'assets/sound/7_1_안전 가옥/New Composition  263 - Orchestrated.mid', coverUrl: 'assets/images/cat_sep_cover.jpg', bpm: '65 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '65 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Orchestral Harp / Oboe'}, tags: ['All Cat', 'Separation', 'Harp'], isPremium: false),
    Track(id: 'cat_separation_02', title: '맑은 오후', description: 'Flute의 느린 템포', audioUrl: 'assets/sound/7_2_창가 자리/New Composition  264.mp3', midiUrl: 'assets/sound/7_2_창가 자리/New Composition  264 - Orchestrated.mid', coverUrl: 'assets/images/cat_sep_cover.jpg', bpm: '60 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '60 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Flute / Acoustic Grand Piano'}, tags: ['All Cat', 'Separation', 'Flute'], isPremium: false),
    Track(id: 'cat_separation_03', title: '평온한 안식처', description: 'Acoustic Grand Piano의 느린 템포', audioUrl: 'assets/sound/7_3_숨숨집의 평화/New Composition  265.mp3', midiUrl: 'assets/sound/7_3_숨숨집의 평화/New Composition  265 - Orchestrated.mid', coverUrl: 'assets/images/cat_sep_cover.jpg', bpm: '55 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '55 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Acoustic Grand Piano'}, tags: ['Small Cat', 'Separation', 'Piano'], isPremium: true),
    Track(id: 'cat_separation_04', title: '부드러운 바람', description: 'Clarinet의 느린 템포', audioUrl: 'assets/sound/7_4_부드러운 공기/New Composition  266.mp3', midiUrl: 'assets/sound/7_4_부드러운 공기/New Composition  266 - Orchestrated.mid', coverUrl: 'assets/images/cat_sep_cover.jpg', bpm: '50 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '50 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Clarinet / Acoustic Grand Piano'}, tags: ['Medium Cat', 'Separation', 'Clarinet'], isPremium: true),
    Track(id: 'cat_separation_05', title: '따뜻한 동행', description: 'Cello의 중간 템포', audioUrl: 'assets/sound/7_5_친구의 목소리/New Composition  267.mp3', midiUrl: 'assets/sound/7_5_친구의 목소리/New Composition  267 - Orchestrated.mid', coverUrl: 'assets/images/cat_sep_cover.jpg', bpm: '65 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '65 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Cello'}, tags: ['Medium Cat', 'Separation', 'Cello'], isPremium: true),
    Track(id: 'cat_separation_06', title: '따스한 시간', description: 'Electric Guitar의 중간 템포', audioUrl: 'assets/sound/7_6_오후의 햇살/New Composition  268.mp3', midiUrl: 'assets/sound/7_6_오후의 햇살/New Composition  268 - Orchestrated.mid', coverUrl: 'assets/images/cat_sep_cover.jpg', bpm: '70 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '70 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Electric Guitar (clean) / Acoustic Grand Piano'}, tags: ['Large Cat', 'Separation', 'Guitar'], isPremium: true),
    Track(id: 'cat_separation_07', title: '편안한 일상', description: 'Piano의 중간 템포', audioUrl: 'assets/sound/7_7_그루밍 타임/New Composition  269.mp3', midiUrl: 'assets/sound/7_7_그루밍 타임/New Composition  269 - Orchestrated.mid', coverUrl: 'assets/images/cat_sep_cover.jpg', bpm: '65 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '65 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Acoustic Grand Piano / Electric Bass (pick)'}, tags: ['Large Cat', 'Separation', 'Piano'], isPremium: true),
    Track(id: 'cat_separation_08', title: '고요한 순간', description: 'Viola의 중간 템포', audioUrl: 'assets/sound/7_8_평온한 관찰/New Composition  270.mp3', midiUrl: 'assets/sound/7_8_평온한 관찰/New Composition  270 - Orchestrated.mid', coverUrl: 'assets/images/cat_sep_cover.jpg', bpm: '65 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '65 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Viola / Acoustic Grand Piano'}, tags: ['Large Cat', 'Separation', 'Viola'], isPremium: true),
  ];

  // 8. Cat Noise Masking (고양이 소음 차단) - 재구성된 제목
  static final List<Track> catNoiseTracks = [
    Track(id: 'cat_noise_01', title: '부드러운 차단', description: 'Piano의 느린 템포', audioUrl: 'assets/sound/8_1_빗소리 커튼/New Composition  271.mp3', midiUrl: 'assets/sound/8_1_빗소리 커튼/New Composition  271 - Orchestrated.mid', coverUrl: 'assets/images/cat_noise_cover.jpg', bpm: '45 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '45 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Acoustic Grand Piano'}, tags: ['All Cat', 'Noise', 'Piano'], isPremium: false),
    Track(id: 'cat_noise_02', title: '자연의 속삭임', description: 'Harp의 느린 템포', audioUrl: 'assets/sound/8_2_바람의 노래/New Composition  272.mp3', midiUrl: 'assets/sound/8_2_바람의 노래/New Composition  272 - Orchestrated.mid', coverUrl: 'assets/images/cat_noise_cover.jpg', bpm: '45 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '45 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Orchestral Harp / Oboe'}, tags: ['All Cat', 'Noise', 'Harp'], isPremium: false),
    Track(id: 'cat_noise_03', title: '따뜻한 보호막', description: 'Piano의 느린 템포', audioUrl: 'assets/sound/8_3_두꺼운 담요/New Composition  273.mp3', midiUrl: 'assets/sound/8_3_두꺼운 담요/New Composition  273 - Orchestrated.mid', coverUrl: 'assets/images/cat_noise_cover.jpg', bpm: '45 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '45 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Acoustic Grand Piano / Contrabass'}, tags: ['Small Cat', 'Noise', 'Piano'], isPremium: true),
    Track(id: 'cat_noise_04', title: '깊은 평온', description: 'Piano의 느린 템포', audioUrl: 'assets/sound/8_4_심해의 고요/New Composition  274.mp3', midiUrl: 'assets/sound/8_4_심해의 고요/New Composition  274 - Orchestrated.mid', coverUrl: 'assets/images/cat_noise_cover.jpg', bpm: '45 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '45 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Acoustic Grand Piano / Contrabass'}, tags: ['Medium Cat', 'Noise', 'Piano'], isPremium: true),
    Track(id: 'cat_noise_05', title: '평화로운 정원', description: 'Bassoon의 느린 템포', audioUrl: 'assets/sound/8_5_새들의 정원/New Composition  275.mp3', midiUrl: 'assets/sound/8_5_새들의 정원/New Composition  275 - Orchestrated.mid', coverUrl: 'assets/images/cat_noise_cover.jpg', bpm: '40 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '40 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Bassoon / Acoustic Grand Piano'}, tags: ['Medium Cat', 'Noise', 'Bassoon'], isPremium: true),
    Track(id: 'cat_noise_06', title: '흐르는 평온', description: 'Harp의 느린 템포', audioUrl: 'assets/sound/8_6_흐르는 시내/New Composition  276.mp3', midiUrl: 'assets/sound/8_6_흐르는 시내/New Composition  276 - Orchestrated.mid', coverUrl: 'assets/images/cat_noise_cover.jpg', bpm: '45 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '45 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Orchestral Harp / Contrabass'}, tags: ['Large Cat', 'Noise', 'Harp'], isPremium: true),
    Track(id: 'cat_noise_07', title: '고요한 방어막', description: 'Piano의 느린 템포', audioUrl: 'assets/sound/8_7_우주 방어막/New Composition  277.mp3', midiUrl: 'assets/sound/8_7_우주 방어막/New Composition  277 - Orchestrated.mid', coverUrl: 'assets/images/cat_noise_cover.jpg', bpm: '40 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '40 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Acoustic Grand Piano'}, tags: ['Large Cat', 'Noise', 'Piano'], isPremium: true),
    Track(id: 'cat_noise_08', title: '부드러운 배경', description: 'Viola의 느린 템포', audioUrl: 'assets/sound/8_8_핑크 노이즈/New Composition  278.mp3', midiUrl: 'assets/sound/8_8_핑크 노이즈/New Composition  278 - Orchestrated.mid', coverUrl: 'assets/images/cat_noise_cover.jpg', bpm: '45 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '45 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Viola / Baritone Sax / Acoustic Grand Piano'}, tags: ['Large Cat', 'Noise', 'Viola'], isPremium: true),
  ];

  // 9. Cat Energy (고양이 활력 증진) - 재구성된 제목
  static final List<Track> catEnergyTracks = [
    Track(id: 'cat_energy_01', title: '경쾌한 질주', description: 'Xylophone의 빠른 템포', audioUrl: 'assets/sound/9_1_우다다 타임/New Composition  279.mp3', midiUrl: 'assets/sound/9_1_우다다 타임/New Composition  279 - Orchestrated.mid', coverUrl: 'assets/images/cat_play_cover.jpg', bpm: '125 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '125 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Xylophone / Electric Bass (pick)'}, tags: ['Large Cat', 'Energy', 'Xylophone'], isPremium: true),
    Track(id: 'cat_energy_02', title: '신나는 추격', description: 'Contrabass의 빠른 템포', audioUrl: 'assets/sound/9_2_잡아라 쥐돌이/New Composition  280.mp3', midiUrl: 'assets/sound/9_2_잡아라 쥐돌이/New Composition  280 - Orchestrated.mid', coverUrl: 'assets/images/cat_play_cover.jpg', bpm: '130 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '130 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Contrabass / Electric Guitar (clean)'}, tags: ['Large Cat', 'Energy', 'Bass'], isPremium: true),
    Track(id: 'cat_energy_03', title: '가벼운 도약', description: 'Flute의 빠른 템포', audioUrl: 'assets/sound/9_3_새 사냥/New Composition  281.mp3', midiUrl: 'assets/sound/9_3_새 사냥/New Composition  281 - Orchestrated.mid', coverUrl: 'assets/images/cat_play_cover.jpg', bpm: '115 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '115 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Flute / Viola'}, tags: ['Large Cat', 'Energy', 'Flute'], isPremium: true),
    Track(id: 'cat_energy_04', title: '활기찬 움직임', description: 'Piano의 빠른 템포', audioUrl: 'assets/sound/9_4_점프 & 런/New Composition  282.mp3', midiUrl: 'assets/sound/9_4_점프 & 런/New Composition  282 - Orchestrated.mid', coverUrl: 'assets/images/cat_play_cover.jpg', bpm: '125 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '125 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Acoustic Grand Piano'}, tags: ['Large Cat', 'Energy', 'Piano'], isPremium: true),
    Track(id: 'cat_energy_05', title: '모험의 시작', description: 'Marimba의 빠른 템포', audioUrl: 'assets/sound/9_5_수풀 속으로/New Composition  283.mp3', midiUrl: 'assets/sound/9_5_수풀 속으로/New Composition  283 - Orchestrated.mid', coverUrl: 'assets/images/cat_play_cover.jpg', bpm: '115 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '115 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Marimba / Acoustic Guitar (steel)'}, tags: ['Large Cat', 'Energy', 'Marimba'], isPremium: true),
    Track(id: 'cat_energy_06', title: '즐거운 놀이', description: 'Piano의 빠른 템포', audioUrl: 'assets/sound/9_6_낚싯대 놀이/New Composition  284.mp3', midiUrl: 'assets/sound/9_6_낚싯대 놀이/New Composition  284 - Orchestrated.mid', coverUrl: 'assets/images/cat_play_cover.jpg', bpm: '130 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '130 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Acoustic Grand Piano'}, tags: ['Large Cat', 'Energy', 'Piano'], isPremium: true),
    Track(id: 'cat_energy_07', title: '신나는 파티', description: 'Distortion Guitar의 빠른 템포', audioUrl: 'assets/sound/9_7_캣닙 파티/New Composition  285.mp3', midiUrl: 'assets/sound/9_7_캣닙 파티/New Composition  285 - Orchestrated.mid', coverUrl: 'assets/images/cat_play_cover.jpg', bpm: '110 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '110 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Distortion Guitar / Electric Bass (pick)'}, tags: ['Large Cat', 'Energy', 'Guitar'], isPremium: true),
    Track(id: 'cat_energy_08', title: '리드미컬한 춤', description: 'Xylophone의 빠른 템포', audioUrl: 'assets/sound/9_8_궁디 팡팡/New Composition  286.mp3', midiUrl: 'assets/sound/9_8_궁디 팡팡/New Composition  286 - Orchestrated.mid', coverUrl: 'assets/images/cat_play_cover.jpg', bpm: '120 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '120 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Xylophone / Acoustic Grand Piano / Tuba'}, tags: ['Large Cat', 'Energy', 'Xylophone'], isPremium: true),
  ];

  // 10. Cat Senior Care (고양이 시니어 케어) - 재구성된 제목
  static final List<Track> catSeniorTracks = [
    Track(id: 'cat_senior_01', title: '치유의 선율', description: 'Piano의 느린 템포', audioUrl: 'assets/sound/10_1_치유의 골골송/New Composition  377.mp3', midiUrl: 'assets/sound/10_1_치유의 골골송/New Composition  377 - Orchestrated.mid', coverUrl: 'assets/images/cat_senior_cover.jpg', bpm: '45 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '45 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Acoustic Grand Piano'}, tags: ['Large Cat', 'Senior', 'Piano'], isPremium: true),
    Track(id: 'cat_senior_02', title: '따뜻한 위로', description: 'Contrabass의 느린 템포', audioUrl: 'assets/sound/10_2_따뜻한 찜질/New Composition  378.mp3', midiUrl: 'assets/sound/10_2_따뜻한 찜질/New Composition  378 - Orchestrated.mid', coverUrl: 'assets/images/cat_senior_cover.jpg', bpm: '50 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '50 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Contrabass / Cello'}, tags: ['Large Cat', 'Senior', 'Bass'], isPremium: true),
    Track(id: 'cat_senior_03', title: '평온한 오후', description: 'Piano의 느린 템포', audioUrl: 'assets/sound/10_3_느린 오후/New Composition  379.mp3', midiUrl: 'assets/sound/10_3_느린 오후/New Composition  379 - Orchestrated.mid', coverUrl: 'assets/images/cat_senior_cover.jpg', bpm: '45 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '45 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Acoustic Grand Piano / Contrabass'}, tags: ['Large Cat', 'Senior', 'Piano'], isPremium: true),
    Track(id: 'cat_senior_04', title: '추억의 여운', description: 'Harp의 느린 템포', audioUrl: 'assets/sound/10_4_기억의 저편/New Composition  380.mp3', midiUrl: 'assets/sound/10_4_기억의 저편/New Composition  380 - Orchestrated.mid', coverUrl: 'assets/images/cat_senior_cover.jpg', bpm: '45 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '45 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Orchestral Harp / Contrabass'}, tags: ['Large Cat', 'Senior', 'Harp'], isPremium: true),
    Track(id: 'cat_senior_05', title: '깊은 공명', description: 'Piano의 느린 템포', audioUrl: 'assets/sound/10_5_영혼의 공명/New Composition  381.mp3', midiUrl: 'assets/sound/10_5_영혼의 공명/New Composition  381 - Orchestrated.mid', coverUrl: 'assets/images/cat_senior_cover.jpg', bpm: '45 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '45 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Acoustic Grand Piano / Oboe'}, tags: ['Large Cat', 'Senior', 'Piano'], isPremium: true),
    Track(id: 'cat_senior_06', title: '따스한 심박', description: 'Viola의 느린 템포', audioUrl: 'assets/sound/10_6_엄마의 심장/New Composition  382.mp3', midiUrl: 'assets/sound/10_6_엄마의 심장/New Composition  382 - Orchestrated.mid', coverUrl: 'assets/images/cat_senior_cover.jpg', bpm: '45 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '45 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Viola / Acoustic Grand Piano'}, tags: ['Large Cat', 'Senior', 'Viola'], isPremium: true),
    Track(id: 'cat_senior_07', title: '고요한 쉼터', description: 'Harp의 느린 템포', audioUrl: 'assets/sound/10_7_고요한 쉼터/New Composition  383.mp3', midiUrl: 'assets/sound/10_7_고요한 쉼터/New Composition  383 - Orchestrated.mid', coverUrl: 'assets/images/cat_senior_cover.jpg', bpm: '45 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '45 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Orchestral Harp / Contrabass'}, tags: ['Large Cat', 'Senior', 'Harp'], isPremium: true),
    Track(id: 'cat_senior_08', title: '편안한 호흡', description: 'Viola의 느린 템포', audioUrl: 'assets/sound/10_8_편안한 호흡/New Composition  384.mp3', midiUrl: 'assets/sound/10_8_편안한 호흡/New Composition  384 - Orchestrated.mid', coverUrl: 'assets/images/cat_senior_cover.jpg', bpm: '45 BPM', technicalSpecs: {'Key': 'Auto', 'Tempo': '45 BPM', 'Harmony': 'Simple Chords II', 'Instruments': 'Viola / Violin'}, tags: ['Large Cat', 'Senior', 'Viola'], isPremium: true),
  ];

  static List<Track> getTracksForMode(String modeId) {
    switch (modeId) {
      case 'sleep': return sleepTracks;
      case 'separation': return separationTracks;
      case 'noise': return noiseTracks;
      case 'energy': return energyTracks;
      case 'senior': return seniorTracks;
      case 'cat_sleep': return catSleepTracks;
      case 'cat_separation': return catSeparationTracks;
      case 'cat_noise': return catNoiseTracks;
      case 'cat_energy': return catEnergyTracks;
      case 'cat_senior': return catSeniorTracks;
      default: return [];
    }
  }
}
