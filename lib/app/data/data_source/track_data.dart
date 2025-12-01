import '../models/track_model.dart';

class TrackData {
  // 1. Deep Sleep (수면 유도)
  static final List<Track> sleepTracks = [
    Track(
      id: 'sleep_01',
      title: '스탠다드 자장가',
      description: '가장 표준적인 피아노',
      audioUrl: 'assets/audio/sleep_01.mp3',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 60 / 4/4박자 / C장조 / 그랜드 피아노 / 단순 코드 진행 I'},
      tags: ['Large Dog', 'Sleep', 'Piano'],
      isPremium: false,
    ),
    Track(
      id: 'sleep_02',
      title: '따뜻한 오후',
      description: '먹먹하고 부드러운 소리',
      audioUrl: 'assets/audio/sleep_02.mp3',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 60 / 4/4박자 / G장조 / 펠트 피아노 / 단순 코드 진행 I'},
      tags: ['Large Dog', 'Sleep', 'Felt Piano'],
      isPremium: false,
    ),
    Track(
      id: 'sleep_03',
      title: '깊은 밤의 꿈',
      description: '깊은 울림 (고급형)',
      audioUrl: 'assets/audio/sleep_03.mp3',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 60 / 4/4박자 / D장조 / 시네마틱 피아노 / 단순 코드 진행 V'},
      tags: ['Large Dog', 'Sleep', 'Cinematic'],
      isPremium: true,
    ),
    Track(
      id: 'sleep_04',
      title: '엄마의 요람',
      description: '3박자 왈츠 (차별화)',
      audioUrl: 'assets/audio/sleep_04.mp3',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 60 / 3/4박자 (왈츠) / Eb장조 / 소프트 피아노 / 단순 코드 진행 I'},
      tags: ['Large Dog', 'Sleep', 'Waltz'],
      isPremium: true,
    ),
    Track(
      id: 'sleep_05',
      title: '깊은 울림',
      description: '중형견용 표준',
      audioUrl: 'assets/audio/sleep_05.mp3',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 70 / 4/4박자 / A장조 / 스타인웨이 D / 단순 코드 진행 I'},
      tags: ['Medium Dog', 'Sleep', 'Standard'],
      isPremium: true,
    ),
    Track(
      id: 'sleep_06',
      title: '포근한 왈츠',
      description: '중형견용 왈츠',
      audioUrl: 'assets/audio/sleep_06.mp3',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 70 / 3/4박자 (왈츠) / F장조 / 펠트 피아노 / 단순 코드 진행 I'},
      tags: ['Medium Dog', 'Sleep', 'Waltz'],
      isPremium: true,
    ),
    Track(
      id: 'sleep_07',
      title: '맑은 아침',
      description: '소형견용 맑은 소리',
      audioUrl: 'assets/audio/sleep_07.mp3',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 80 / 4/4박자 / C장조 / 업라이트 피아노 / 단순 코드 진행 I'},
      tags: ['Small Dog', 'Sleep', 'Clear'],
      isPremium: true,
    ),
    Track(
      id: 'sleep_08',
      title: '사뿐한 왈츠',
      description: '오르골 느낌 추가',
      audioUrl: 'assets/audio/sleep_08.mp3',
      coverUrl: 'assets/images/sleep_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 80 / 3/4박자 (왈츠) / Bb장조 / 첼레스타+피아노 / 단순 코드 진행 I'},
      tags: ['Small Dog', 'Sleep', 'Orgel'],
      isPremium: true,
    ),
  ];

  // 2. Calm Shelter (분리불안)
  static final List<Track> separationTracks = [
    Track(
      id: 'separation_01',
      title: '묵직한 위로',
      description: '첼로의 묵직한 저음',
      audioUrl: 'assets/audio/sep_01.mp3',
      coverUrl: 'assets/images/sep_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 60 / 스타일: 챔버 오케스트라 / 첼로 솔로'},
      tags: ['Large Dog', 'Separation', 'Cello'],
      isPremium: false,
    ),
    Track(
      id: 'separation_02',
      title: '함께하는 시간',
      description: '현악 4중주의 조화',
      audioUrl: 'assets/audio/sep_02.mp3',
      coverUrl: 'assets/images/sep_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 60 / 스타일: 챔버 오케스트라 / 현악 앙상블'},
      tags: ['Large Dog', 'Separation', 'Ensemble'],
      isPremium: false,
    ),
    Track(
      id: 'separation_03',
      title: '안정된 호흡',
      description: '비올라의 중저음',
      audioUrl: 'assets/audio/sep_03.mp3',
      coverUrl: 'assets/images/sep_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 70 / 스타일: 솔로 / 비올라'},
      tags: ['Medium Dog', 'Separation', 'Viola'],
      isPremium: true,
    ),
    Track(
      id: 'separation_04',
      title: '평온한 기다림',
      description: '부드러운 현악기',
      audioUrl: 'assets/audio/sep_04.mp3',
      coverUrl: 'assets/images/sep_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 70 / 스타일: 듀엣 / 바이올린+첼로'},
      tags: ['Medium Dog', 'Separation', 'Duet'],
      isPremium: true,
    ),
    Track(
      id: 'separation_05',
      title: '가벼운 위로',
      description: '바이올린의 선율',
      audioUrl: 'assets/audio/sep_05.mp3',
      coverUrl: 'assets/images/sep_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 80 / 스타일: 솔로 / 바이올린'},
      tags: ['Small Dog', 'Separation', 'Violin'],
      isPremium: true,
    ),
    Track(
      id: 'separation_06',
      title: '작은 친구',
      description: '밝고 따뜻한 현악',
      audioUrl: 'assets/audio/sep_06.mp3',
      coverUrl: 'assets/images/sep_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 80 / 스타일: 챔버 / 소규모 앙상블'},
      tags: ['Small Dog', 'Separation', 'Chamber'],
      isPremium: true,
    ),
  ];

  // 3. Noise Masking (소음 차단)
  static final List<Track> noiseTracks = [
    Track(
      id: 'noise_01',
      title: '빗소리 차단',
      description: '브라운 노이즈 + 저음',
      audioUrl: 'assets/audio/noise_01.mp3',
      coverUrl: 'assets/images/noise_cover.jpg',
      technicalSpecs: {'오디오 설정': '브라운 노이즈 (저주파 강조) + 앰비언트 패드'},
      tags: ['Large Dog', 'Noise', 'Brown Noise'],
      isPremium: false,
    ),
    Track(
      id: 'noise_02',
      title: '도시 소음 차단',
      description: '핑크 노이즈 + 피아노',
      audioUrl: 'assets/audio/noise_02.mp3',
      coverUrl: 'assets/images/noise_cover.jpg',
      technicalSpecs: {'오디오 설정': '핑크 노이즈 (전 대역 고루 분포) + 슬로우 피아노'},
      tags: ['Medium Dog', 'Noise', 'Pink Noise'],
      isPremium: false,
    ),
    Track(
      id: 'noise_03',
      title: '백색 소음',
      description: '화이트 노이즈 + 자연음',
      audioUrl: 'assets/audio/noise_03.mp3',
      coverUrl: 'assets/images/noise_cover.jpg',
      technicalSpecs: {'오디오 설정': '화이트 노이즈 (고주파 포함) + 새소리/물소리'},
      tags: ['Small Dog', 'Noise', 'White Noise'],
      isPremium: true,
    ),
  ];

  // 4. Energy Boost (활력 증진)
  static final List<Track> energyTracks = [
    Track(
      id: 'energy_01',
      title: '아침 산책',
      description: '경쾌한 마림바',
      audioUrl: 'assets/audio/energy_01.mp3',
      coverUrl: 'assets/images/play_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 100 / 장조 / 마림바 & 퍼커션'},
      tags: ['All Dogs', 'Energy', 'Marimba'],
      isPremium: false,
    ),
    Track(
      id: 'energy_02',
      title: '신나는 놀이',
      description: '밝은 피아노 리듬',
      audioUrl: 'assets/audio/energy_02.mp3',
      coverUrl: 'assets/images/play_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 110 / 장조 / 업라이트 피아노'},
      tags: ['All Dogs', 'Energy', 'Piano'],
      isPremium: false,
    ),
    Track(
      id: 'energy_03',
      title: '오후의 활력',
      description: '기타와 드럼',
      audioUrl: 'assets/audio/energy_03.mp3',
      coverUrl: 'assets/images/play_cover.jpg',
      technicalSpecs: {'AIVA 설정': '템포: 105 / 장조 / 어쿠스틱 기타'},
      tags: ['All Dogs', 'Energy', 'Guitar'],
      isPremium: true,
    ),
  ];

  // 5. Senior Care (시니어 펫 케어)
  static final List<Track> seniorTracks = [
    Track(
      id: 'senior_01',
      title: '편안한 휴식',
      description: '40Hz 진동 (대형견)',
      audioUrl: 'assets/audio/senior_01.mp3',
      coverUrl: 'assets/images/senior_cover.jpg',
      technicalSpecs: {'과학적 설계': '40Hz 감마파 + 60 BPM (대형견 심박수 동기화)'},
      tags: ['Large Dog', 'Senior', 'Vibration'],
      isPremium: false,
    ),
    Track(
      id: 'senior_02',
      title: '부드러운 케어',
      description: '50Hz 진동 (중형견)',
      audioUrl: 'assets/audio/senior_02.mp3',
      coverUrl: 'assets/images/senior_cover.jpg',
      technicalSpecs: {'과학적 설계': '50Hz 진동 + 70 BPM (중형견 심박수 동기화)'},
      tags: ['Medium Dog', 'Senior', 'Vibration'],
      isPremium: false,
    ),
    Track(
      id: 'senior_03',
      title: '심신 안정',
      description: '60Hz 진동 (소형견)',
      audioUrl: 'assets/audio/senior_03.mp3',
      coverUrl: 'assets/images/senior_cover.jpg',
      technicalSpecs: {'과학적 설계': '60Hz 진동 + 80 BPM (소형견 심박수 동기화)'},
      tags: ['Small Dog', 'Senior', 'Vibration'],
      isPremium: true,
    ),
    Track(
      id: 'senior_04',
      title: '시니어 펫의 활력',
      description: '복합 진동 케어',
      audioUrl: 'assets/audio/senior_04.mp3',
      coverUrl: 'assets/images/senior_cover.jpg',
      technicalSpecs: {'과학적 설계': '40-60Hz 가변 진동 + 뇌파 동조'},
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
