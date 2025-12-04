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
      technicalSpecs: {
        'Key': 'C Major',
        'Tempo': '60 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Grand Piano / Sub Bass'
      },
      tags: ['Large Dog', 'Sleep', 'Piano'],
      isPremium: false,
    ),
    Track(
      id: 'sleep_02',
      title: '따뜻한 오후',
      description: '먹먹하고 부드러운 소리',
      audioUrl: 'assets/sound/1_2.mp3',
      midiUrl: 'assets/sound/1_2.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {
        'Key': 'G Major',
        'Tempo': '60 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Grand Piano (Softest) / Warm Pad'
      },
      tags: ['Large Dog', 'Sleep', 'Felt Piano'],
      isPremium: false,
    ),
    Track(
      id: 'sleep_03',
      title: '깊은 밤의 꿈',
      description: '깊은 울림이 있는 꿈결 같은 곡',
      audioUrl: 'assets/sound/1_3.mp3',
      midiUrl: 'assets/sound/1_3.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {
        'Key': 'D Major',
        'Tempo': '55 BPM',
        'Harmony': 'Simple Chords IV',
        'Instruments': 'String Ensemble / Sub Bass'
      },
      tags: ['Large Dog', 'Sleep', 'Cinematic'],
      isPremium: true,
    ),
    Track(
      id: 'sleep_04',
      title: '엄마의 요람',
      description: '포근하게 감싸주는 요람의 노래',
      audioUrl: 'assets/sound/1_4.mp3',
      midiUrl: 'assets/sound/1_4.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {
        'Key': 'Eb Major',
        'Tempo': '60 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'String Ensemble / Warm Pad'
      },
      tags: ['Large Dog', 'Sleep', 'Waltz'],
      isPremium: true,
    ),
    Track(
      id: 'sleep_05',
      title: '깊은 울림',
      description: '마음을 차분하게 하는 깊은 울림',
      audioUrl: 'assets/sound/1_5.mp3',
      midiUrl: 'assets/sound/1_5.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {
        'Key': 'A Major',
        'Tempo': '70 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Grand Piano / String Ensemble'
      },
      tags: ['Medium Dog', 'Sleep', 'Standard'],
      isPremium: true,
    ),
    Track(
      id: 'sleep_06',
      title: '포근한 왈츠',
      description: '부드럽게 흔들리는 왈츠 리듬',
      audioUrl: 'assets/sound/1_6.mp3',
      midiUrl: 'assets/sound/1_6.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {
        'Key': 'F Major',
        'Tempo': '70 BPM',
        'Harmony': 'Simple Chords II',
        'Instruments': 'Grand Piano / Upright Bass'
      },
      tags: ['Medium Dog', 'Sleep', 'Waltz'],
      isPremium: true,
    ),
    Track(
      id: 'sleep_07',
      title: '맑은 아침',
      description: '상쾌하고 맑은 아침의 소리',
      audioUrl: 'assets/sound/1_7.mp3',
      midiUrl: 'assets/sound/1_7.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {
        'Key': 'C Major',
        'Tempo': '80 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Harp / Woodwinds'
      },
      tags: ['Small Dog', 'Sleep', 'Clear'],
      isPremium: true,
    ),
    Track(
      id: 'sleep_08',
      title: '사뿐한 왈츠',
      description: '가볍고 사뿐한 왈츠',
      audioUrl: 'assets/sound/1_8.mp3',
      midiUrl: 'assets/sound/1_8.mid',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {
        'Key': 'Bb Major',
        'Tempo': '80 BPM',
        'Harmony': 'Simple Chords III',
        'Instruments': 'Celesta / Bassoon'
      },
      tags: ['Small Dog', 'Sleep', 'Orgel'],
      isPremium: true,
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
      technicalSpecs: {
        'Key': 'C Minor',
        'Tempo': '60 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Cello / String Ensemble'
      },
      tags: ['Large Dog', 'Separation', 'Cello'],
      isPremium: false,
    ),
    Track(
      id: 'separation_02',
      title: '따뜻한 공명',
      description: '공간을 채우는 따뜻한 공명',
      audioUrl: 'assets/sound/2_2.mp3',
      midiUrl: 'assets/sound/2_2.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': 'Slow',
        'Harmony': 'Simple Chords IV',
        'Instruments': 'Warm Pad / 808 Bass'
      },
      tags: ['Large Dog', 'Separation', 'Ensemble'],
      isPremium: false,
    ),
    Track(
      id: 'separation_03',
      title: '균형 잡힌 안정',
      description: '비올라가 주는 균형 잡힌 안정감',
      audioUrl: 'assets/sound/2_3.mp3',
      midiUrl: 'assets/sound/2_3.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '70 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Viola / Sub Bass'
      },
      tags: ['Medium Dog', 'Separation', 'Viola'],
      isPremium: true,
    ),
    Track(
      id: 'separation_04',
      title: '포근한 공기',
      description: '공기처럼 감싸는 포근함',
      audioUrl: 'assets/sound/2_4.mp3',
      midiUrl: 'assets/sound/2_4.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': 'Slow',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Soft Pad / Drone Bass'
      },
      tags: ['Medium Dog', 'Separation', 'Duet'],
      isPremium: true,
    ),
    Track(
      id: 'separation_05',
      title: '산뜻한 안정',
      description: '하프 선율의 산뜻한 안정',
      audioUrl: 'assets/sound/2_5.mp3',
      midiUrl: 'assets/sound/2_5.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      technicalSpecs: {
        'Key': 'C Major',
        'Tempo': '80 BPM',
        'Harmony': 'Simple Chords III',
        'Instruments': 'Harp / String Ensemble'
      },
      tags: ['Small Dog', 'Separation', 'Violin'],
      isPremium: true,
    ),
    Track(
      id: 'separation_06',
      title: '밝은 공기',
      description: '밝고 따뜻한 분위기의 곡',
      audioUrl: 'assets/sound/2_6.mp3',
      midiUrl: 'assets/sound/2_6.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': 'Slow',
        'Harmony': 'Intermediate Mixed Chords I',
        'Instruments': 'Bright Pad / 808 Bass'
      },
      tags: ['Small Dog', 'Separation', 'Chamber'],
      isPremium: true,
    ),
    Track(
      id: 'separation_07',
      title: '평온한 오후',
      description: '기타 선율과 함께하는 평온한 오후',
      audioUrl: 'assets/sound/2_7.mp3',
      midiUrl: 'assets/sound/2_7.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      technicalSpecs: {
        'Key': 'G Major',
        'Tempo': '65 BPM',
        'Harmony': 'Simple Chords II',
        'Instruments': 'Acoustic Guitar / Electric Bass'
      },
      tags: ['Small Dog', 'Separation', 'Chamber'],
      isPremium: true,
    ),
    Track(
      id: 'separation_08',
      title: '숲속의 쉼터',
      description: '숲속 쉼터 같은 편안한 피아노',
      audioUrl: 'assets/sound/2_8.mp3',
      midiUrl: 'assets/sound/2_8.mid',
      coverUrl: 'assets/images/sep_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '65 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Grand Piano / Woodwinds'
      },
      tags: ['Small Dog', 'Separation', 'Chamber'],
      isPremium: true,
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
      technicalSpecs: {
        'Key': 'N/A',
        'Tempo': '60 BPM',
        'Harmony': 'Simple Chords IV',
        'Instruments': 'Analog Pad / 808 Bass'
      },
      tags: ['Large Dog', 'Noise', 'Brown Noise'],
      isPremium: false,
    ),
    Track(
      id: 'noise_02',
      title: '깊은 방패',
      description: '깊고 든든한 소리 방패',
      audioUrl: 'assets/sound/3_2.mp3',
      midiUrl: 'assets/sound/3_2.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '60 BPM',
        'Harmony': 'Intermediate Mixed Chords I',
        'Instruments': 'Dark Pad / 808 Bass'
      },
      tags: ['Medium Dog', 'Noise', 'Pink Noise'],
      isPremium: false,
    ),
    Track(
      id: 'noise_03',
      title: '일상의 평온',
      description: '일상 속 평온함을 주는 소리',
      audioUrl: 'assets/sound/3_3.mp3',
      midiUrl: 'assets/sound/3_3.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      technicalSpecs: {
        'Key': 'N/A',
        'Tempo': '55 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Warm Pad / Simple Bass'
      },
      tags: ['Small Dog', 'Noise', 'White Noise'],
      isPremium: true,
    ),
    Track(
      id: 'noise_04',
      title: '든든한 방음벽',
      description: '소음을 막아주는 든든한 저음',
      audioUrl: 'assets/sound/3_4.mp3',
      midiUrl: 'assets/sound/3_4.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '60 BPM',
        'Harmony': 'Simple Chords IV',
        'Instruments': 'Low Pad / Drone Bass'
      },
      tags: ['Small Dog', 'Noise', 'White Noise'],
      isPremium: true,
    ),
    Track(
      id: 'noise_05',
      title: '산뜻한 보호막',
      description: '가볍고 산뜻한 소리 보호막',
      audioUrl: 'assets/sound/3_5.mp3',
      midiUrl: 'assets/sound/3_5.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      technicalSpecs: {
        'Key': 'N/A',
        'Tempo': '70 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Atmosphere / Simple Bass'
      },
      tags: ['Small Dog', 'Noise', 'White Noise'],
      isPremium: true,
    ),
    Track(
      id: 'noise_06',
      title: '포근한 담요',
      description: '담요처럼 포근하게 감싸는 소리',
      audioUrl: 'assets/sound/3_6.mp3',
      midiUrl: 'assets/sound/3_6.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '70 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'String Ensemble / Cello'
      },
      tags: ['Small Dog', 'Noise', 'White Noise'],
      isPremium: true,
    ),
    Track(
      id: 'noise_07',
      title: '우주 여행',
      description: '신비로운 우주 공간 같은 느낌',
      audioUrl: 'assets/sound/3_7.mp3',
      midiUrl: 'assets/sound/3_7.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '80 BPM',
        'Harmony': 'Intermediate Mixed Chords II',
        'Instruments': 'Space Pad / Deep Bass'
      },
      tags: ['Small Dog', 'Noise', 'White Noise'],
      isPremium: true,
    ),
    Track(
      id: 'noise_08',
      title: '깊은 바다',
      description: '심해처럼 깊고 고요한 소리',
      audioUrl: 'assets/sound/3_8.mp3',
      midiUrl: 'assets/sound/3_8.mid',
      coverUrl: 'assets/images/noise_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '80 BPM',
        'Harmony': 'Simple Chords IV',
        'Instruments': 'Filter Pad / 808 Bass'
      },
      tags: ['Small Dog', 'Noise', 'White Noise'],
      isPremium: true,
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
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '95 BPM',
        'Harmony': 'Advanced Jazz Chords',
        'Instruments': 'Grand Piano / Double Bass'
      },
      tags: ['All Dogs', 'Energy', 'Marimba'],
      isPremium: false,
    ),
    Track(
      id: 'energy_02',
      title: '활기찬 터그',
      description: '에너지 넘치는 기타 사운드',
      audioUrl: 'assets/sound/4_2.mp3',
      midiUrl: 'assets/sound/4_2.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '105 BPM',
        'Harmony': 'Power Chords',
        'Instruments': 'Electric Guitar / Electric Bass'
      },
      tags: ['All Dogs', 'Energy', 'Piano'],
      isPremium: false,
    ),
    Track(
      id: 'energy_03',
      title: '경쾌한 총총',
      description: '가볍게 뛰어노는 듯한 피아노',
      audioUrl: 'assets/sound/4_3.mp3',
      midiUrl: 'assets/sound/4_3.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '105 BPM',
        'Harmony': 'Simple Chords III',
        'Instruments': 'Grand Piano / Electric Bass'
      },
      tags: ['All Dogs', 'Energy', 'Guitar'],
      isPremium: true,
    ),
    Track(
      id: 'energy_04',
      title: '신나는 술래',
      description: '신디사이저의 펑키한 리듬',
      audioUrl: 'assets/sound/4_4.mp3',
      midiUrl: 'assets/sound/4_4.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '115 BPM',
        'Harmony': '7th Chords II',
        'Instruments': 'Synth Lead / Synth Bass'
      },
      tags: ['All Dogs', 'Energy', 'Guitar'],
      isPremium: true,
    ),
    Track(
      id: 'energy_05',
      title: '사뿐한 총총',
      description: '어쿠스틱 기타의 경쾌한 발걸음',
      audioUrl: 'assets/sound/4_5.mp3',
      midiUrl: 'assets/sound/4_5.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '115 BPM',
        'Harmony': 'Simple Chords III',
        'Instruments': 'Acoustic Guitar / Acoustic Bass'
      },
      tags: ['All Dogs', 'Energy', 'Guitar'],
      isPremium: true,
    ),
    Track(
      id: 'energy_06',
      title: '신나는 우다다',
      description: '글로켄슈필의 맑고 신나는 소리',
      audioUrl: 'assets/sound/4_6.mp3',
      midiUrl: 'assets/sound/4_6.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '125 BPM',
        'Harmony': 'Simple Chords III',
        'Instruments': 'Glockenspiel / Electric Bass'
      },
      tags: ['All Dogs', 'Energy', 'Guitar'],
      isPremium: true,
    ),
    Track(
      id: 'energy_07',
      title: '피크닉',
      description: '소풍 가는 길의 설렘',
      audioUrl: 'assets/sound/4_7.mp3',
      midiUrl: 'assets/sound/4_7.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '100 BPM',
        'Harmony': 'Simple Chords II',
        'Instruments': 'Acoustic Guitar / Electric Bass'
      },
      tags: ['All Dogs', 'Energy', 'Guitar'],
      isPremium: true,
    ),
    Track(
      id: 'energy_08',
      title: '댄스 타임',
      description: '80년대 디스코 스타일의 댄스곡',
      audioUrl: 'assets/sound/4_8.mp3',
      midiUrl: 'assets/sound/4_8.mid',
      coverUrl: 'assets/images/play_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '110 BPM',
        'Harmony': '7th Chords II',
        'Instruments': 'Poly Synth / Funky Bass'
      },
      tags: ['All Dogs', 'Energy', 'Guitar'],
      isPremium: true,
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
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '60 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Warm Pad / 808 Bass'
      },
      tags: ['Large Dog', 'Senior', 'Vibration'],
      isPremium: false,
    ),
    Track(
      id: 'senior_02',
      title: '깊은 안정',
      description: '현악 앙상블의 깊은 안정감',
      audioUrl: 'assets/sound/5_2.mp3',
      midiUrl: 'assets/sound/5_2.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '60 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'String Ensemble / Double Bass'
      },
      tags: ['Medium Dog', 'Senior', 'Vibration'],
      isPremium: false,
    ),
    Track(
      id: 'senior_03',
      title: '부드러운 공명',
      description: '부드럽게 울려 퍼지는 공명',
      audioUrl: 'assets/sound/5_3.mp3',
      midiUrl: 'assets/sound/5_3.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '55 BPM',
        'Harmony': 'Simple Chords IV',
        'Instruments': 'Warm Pad / Drone Bass'
      },
      tags: ['Small Dog', 'Senior', 'Vibration'],
      isPremium: true,
    ),
    Track(
      id: 'senior_04',
      title: '편안한 휴식',
      description: '가장 부드러운 피아노 소리',
      audioUrl: 'assets/sound/5_4.mp3',
      midiUrl: 'assets/sound/5_4.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      technicalSpecs: {
        'Key': 'G Major',
        'Tempo': '60 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Grand Piano (Softest) / Acoustic Bass'
      },
      tags: ['All Dogs', 'Senior', 'Complex Vibration'],
      isPremium: true,
    ),
    Track(
      id: 'senior_05',
      title: '포근한 온기',
      description: '아날로그 패드의 포근한 온기',
      audioUrl: 'assets/sound/5_5.mp3',
      midiUrl: 'assets/sound/5_5.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '70 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Analog Pad / 808 Bass'
      },
      tags: ['All Dogs', 'Senior', 'Complex Vibration'],
      isPremium: true,
    ),
    Track(
      id: 'senior_06',
      title: '산뜻한 평온',
      description: '하프와 현악의 조화',
      audioUrl: 'assets/sound/5_6.mp3',
      midiUrl: 'assets/sound/5_6.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      technicalSpecs: {
        'Key': 'F Major',
        'Tempo': '70 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Harp / String Ensemble'
      },
      tags: ['All Dogs', 'Senior', 'Complex Vibration'],
      isPremium: true,
    ),
    Track(
      id: 'senior_07',
      title: '영혼의 안식',
      description: '콰이어와 오르간의 안식',
      audioUrl: 'assets/sound/5_7.mp3',
      midiUrl: 'assets/sound/5_7.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '80 BPM',
        'Harmony': 'Simple Chords I',
        'Instruments': 'Choir / Organ'
      },
      tags: ['All Dogs', 'Senior', 'Complex Vibration'],
      isPremium: true,
    ),
    Track(
      id: 'senior_08',
      title: '자연의 품',
      description: '플루트 소리가 주는 자연의 느낌',
      audioUrl: 'assets/sound/5_8.mp3',
      midiUrl: 'assets/sound/5_8.mid',
      coverUrl: 'assets/images/senior_cover.jpg',
      technicalSpecs: {
        'Key': 'Auto',
        'Tempo': '80 BPM',
        'Harmony': 'Simple Chords IV',
        'Instruments': 'Flute / Acoustic Bass'
      },
      tags: ['All Dogs', 'Senior', 'Complex Vibration'],
      isPremium: true,
    ),
  ];

  static List<Track> getTracksForMode(String modeId) {
    switch (modeId) {
      case 'sleep': return sleepTracks;
      case 'separation': return separationTracks;
      case 'noise': return noiseTracks;
      case 'energy': return energyTracks;
      case 'senior': return seniorTracks;
      default: return [];
    }
  }
}
