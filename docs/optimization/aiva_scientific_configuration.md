# AIVA Scientific Configuration Guide for PetBeats

이 문서는 **동물음악학(Zoomusicology)** 및 **생체음향학(Bioacoustics)** 연구 논문을 기반으로, AIVA에서 생성할 **강아지 40곡**과 **고양이 40곡**, 총 80곡의 구체적인 설정값을 정의합니다.

## 📚 과학적 설계 원칙 (Scientific Design Principles)

| 구분 | 강아지 (Dog) | 고양이 (Cat) |
| :--- | :--- | :--- |
| **핵심 주파수** | **Low-Mid Frequency** (저-중음역) | **High Frequency** (고음역, 1옥타브 위) |
| **선호 템포** | **50~60 BPM** (대형견 휴식 심박수) | **Purring (20-50Hz)** / **Suckling Rhythm** |
| **악기 구성** | Solo Piano, Cello, Classical Guitar | Harp, Flute, Violin, Synth (Purr-like) |
| **음향 기법** | Simple Melody, Long Sustain | **Glissando** (미끄러짐), Pizzicato |
| **주의 사항** | 복잡한 재즈, 헤비메탈 금지 | 갑작스러운 큰 소리(Startle) 금지 |

---

## 🐶 강아지 (Dog) 트랙 구성 (40곡)

### 1. Deep Sleep (수면 유도)
| No | 타겟 | 곡 제목 (Title) | AIVA Style | Tempo | Key | Instrument | 과학적 의도 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 공용 | 스탠다드 자장가 | Solo Piano | 60 | C Major | Grand Piano | 표준 심박수 동조 (Kogan) |
| 2 | 공용 | 따뜻한 오후 | Solo Piano | 60 | G Major | Felt Piano | 고음역 배제, 부드러운 톤 |
| 3 | 대형 | 깊은 밤의 꿈 | Cinematic (Slow) | 55 | D Major | Cello + Piano | 대형견의 느린 심박수 (50-60) |
| 4 | 대형 | 엄마의 요람 | Chamber | 60 | Eb Major | String Quartet | 3/4박자의 흔들림(Rocking) 효과 |
| 5 | 중형 | 깊은 울림 | Solo Piano | 70 | A Major | Steinway | 중형견 심박수 고려 |
| 6 | 중형 | 포근한 왈츠 | Solo Piano | 70 | F Major | Felt Piano | 부드러운 왈츠 리듬 |
| 7 | 소형 | 맑은 아침 | Solo Harp | 80 | C Major | Harp | 소형견/고양이 선호 고음역 (Snowdon) |
| 8 | 소형 | 사뿐한 왈츠 | Ensemble | 80 | Bb Major | Celesta + Piano | 오르골 같은 고음역 자극 |

### 2. Calm Shelter (분리불안)
| No | 타겟 | 곡 제목 (Title) | AIVA Style | Tempo | Key | Instrument | 과학적 의도 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 대형 | 묵직한 위로 | Cello Solo | 60 | C Minor | Cello | 첼로의 저음은 개의 짖음을 억제함 (Wells) |
| 2 | 대형 | 따뜻한 공명 | Ambient | Slow | Auto | Low Pad | 공간을 채워 고립감 해소 |
| 3 | 중형 | 균형 잡힌 안정 | String Ens. | 70 | Auto | Viola | 너무 무겁지 않은 중음역 |
| 4 | 중형 | 포근한 공기 | Ambient | Slow | Auto | Warm Pad | 백색소음 효과 |
| 5 | 소형 | 산뜻한 안정 | Solo Harp | 80 | C Major | Harp | 고양이/소형견의 청각적 선호 (맑은 소리) |
| 6 | 소형 | 밝은 공기 | Ambient | Slow | Auto | Bright Pad | 고음역 앰비언트 |
| 7 | 공용 | 평온한 오후 | Guitar | 65 | G Major | Classical Guitar | 사람의 손길(Touch)을 연상시키는 따뜻함 |
| 8 | 공용 | 숲속의 쉼터 | Meditation | 65 | Auto | Flute + Piano | 자연의 소리와 유사한 플루트 |

### 3. Noise Masking (소음 차폐)
| No | 타겟 | 곡 제목 (Title) | AIVA Style | Tempo | Key | Instrument | 과학적 의도 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 대형 | 부드러운 장막 | Ambient | N/A | N/A | Pink Noise Mix | 전대역 차폐 (빗소리 유사) |
| 2 | 대형 | 깊은 방패 | Dark Ambient | Very Slow | Auto | Sub-bass | 천둥 등 저주파 소음 상쇄 |
| 3 | 중형 | 일상의 평온 | Ambient | N/A | N/A | Stream Mix | 불규칙한 생활 소음 마스킹 |
| 4 | 중형 | 든든한 방음벽 | Ambient | Very Slow | Auto | Low-Mid Pad | 중저음역대 방어 |
| 5 | 소형 | 산뜻한 보호막 | Nature | N/A | N/A | Birds Mix | 고음역 소음(사이렌 등) 분산 |
| 6 | 소형 | 포근한 담요 | Ambient | Medium | Auto | Warm Pad | 포근한 감싸안음 효과 |
| 7 | 공용 | 우주 여행 | Space | No Beat | Auto | Shimmer | 광활한 공간감으로 좁은 공간 스트레스 완화 |
| 8 | 공용 | 깊은 바다 | Drone | No Beat | Auto | Low Filter | 물속 효과 (자궁 내 환경 모방) |

### 4. Happy Play (실내 놀이)
| No | 타겟 | 곡 제목 (Title) | AIVA Style | Tempo | Key | Instrument | 과학적 의도 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 대형 | 리드미컬 산책 | Cool Jazz | 95 | Auto | Upright Bass | 걷는 템포와 동기화 (단, 복잡한 재즈 X) |
| 2 | 대형 | 활기찬 터그 | Soft Rock | 105 | Auto | Clean Guitar | 록 비트이나 디스토션 없는 클린 톤 |
| 3 | 중형 | 경쾌한 총총 | Acoustic Pop | 105 | Auto | Piano + Guitar | 밝고 경쾌한 팝 (Wells 연구: 팝은 중립/긍정) |
| 4 | 중형 | 신나는 술래 | Synth Pop | 115 | Auto | Plucky Synth | 통통 튀는 소리로 호기심 자극 |
| 5 | 소형 | 사뿐한 총총 | Folk | 115 | Auto | Ukulele | 소형견의 가벼운 발걸음 매칭 |
| 6 | 소형 | 신나는 우다다 | Indie Pop | 125 | Auto | Glockenspiel | 고음역 타격음 (장난감 소리 유사) |
| 7 | 공용 | 피크닉 | Country | 100 | Auto | Acoustic Guitar | 야외 활동의 경쾌함 |
| 8 | 공용 | 댄스 타임 | Disco (Soft) | 110 | Auto | Funky Bass | 꼬리 흔들기 리듬 |

### 5. Senior Care (노령견)
| No | 타겟 | 곡 제목 (Title) | AIVA Style | Tempo | Key | Instrument | 과학적 의도 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 대형 | 치유의 주파수 | Meditation | No Beat | Auto | Singing Bowl | 진동을 통한 통증 완화 (Vibroacoustic) |
| 2 | 대형 | 깊은 안정 | Slow Strings | 45 | Auto | Cello + Bass | 매우 느린 심박수 동조 |
| 3 | 중형 | 부드러운 공명 | Drone | No Beat | Auto | Warm Pad | 끊김 없는 소리로 안정감 유지 |
| 4 | 중형 | 편안한 휴식 | Solo Piano | 50 | G Major | Piano (Soft) | 자극 최소화 |
| 5 | 소형 | 포근한 온기 | Ambient | No Beat | Auto | Mid-Pad | 체온 유지 느낌 |
| 6 | 소형 | 산뜻한 평온 | Solo Harp | 50 | F Major | Harp | 관절에 부담 없는 맑은 소리 |
| 7 | 공용 | 영혼의 안식 | Choral | 45 | Auto | Soft Voice | 주인의 목소리와 유사한 허밍 (안전 기지) |
| 8 | 공용 | 자연의 품 | Nature | Slow | Auto | Flute | 자연 친화적 소리 |

---

## 🐱 고양이 (Cat) 트랙 구성 (40곡)

### 1. Deep Sleep (수면 유도)
| No | 타겟 | 곡 제목 (Title) | AIVA Style | Tempo | Key | Instrument | 과학적 의도 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 전묘종 | 골골송 자장가 | Ambient | No Beat | Auto | Synth Pad + Sub Bass | 골골송(Purr) 진동 강조 (햅틱 필수) |
| 2 | 전묘종 | 꿈꾸는 젤리 | Solo Piano | Slow | F Major | Piano (Soft) | 부드럽고 몽글몽글한 피아노 |
| 3 | 키튼 | 아기냥의 낮잠 | Lullaby | Slow | C Major | Celesta (Music Box) | 오르골 같은 영롱한 소리 |
| 4 | 키튼 | 엄마의 품 | Meditation | Very Slow | Auto | Harp + Flute | 하프의 부드러운 글리산도 |
| 5 | 성묘 | 깊은 밤의 우주 | Space Ambient | Slow | Auto | Shimmer Pad | 우주에 떠 있는 듯한 무중력감 |
| 6 | 성묘 | 달빛 소나타 | Classical | Slow | Auto | Piano + Cello | 첼로의 고음역대 선율 |
| 7 | 노묘 | 따뜻한 온돌 | Drone | No Beat | Auto | Low-Mid Pad | 끊기지 않는 따뜻한 지속음 |
| 8 | 노묘 | 치유의 단잠 | Meditation | Slow | G Major | Singing Bowl | 깊은 휴식을 위한 공명음 |

### 2. Calm Shelter (분리불안)
| No | 타겟 | 곡 제목 (Title) | AIVA Style | Tempo | Key | Instrument | 과학적 의도 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 전묘종 | 안전 가옥 | Chamber Pop | 60-70 | Auto | Harp Solo | 하프의 안정적인 튕김 |
| 2 | 전묘종 | 창가 자리 | Classical | Slow | D Major | Flute + Piano | 플루트의 새소리 같은 느낌 |
| 3 | 예민 | 숨숨집의 평화 | Ambient | Slow | Auto | Soft Pad | 자극이 적은 은신처 느낌 |
| 4 | 예민 | 부드러운 공기 | Meditation | Slow | Auto | Wind Chimes (Soft) | 윈드차임의 자연스러운 소리 |
| 5 | 외로움 | 친구의 목소리 | Solo Cello | Slow | A Major | Cello (High Octave) | 사람 목소리와 비슷한 첼로 고음 |
| 6 | 외로움 | 오후의 햇살 | Acoustic Pop | Slow | Auto | Nylon Guitar | 따뜻한 기타 선율 |
| 7 | 전묘종 | 그루밍 타임 | Lo-fi (Chill) | 70 | Auto | Electric Piano | 반복적인 그루밍 리듬 |
| 8 | 전묘종 | 평온한 관찰 | Cinematic | Slow | Auto | Strings (Sustain) | 넓은 시야를 여는 배경음 |

### 3. Noise Masking (소음 차폐)
| No | 타겟 | 곡 제목 (Title) | AIVA Style | Tempo | Key | Instrument | 과학적 의도 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 전묘종 | 빗소리 커튼 | Lo-fi | N/A | Auto | Soft Rain + Piano | 빗소리 + 피아노 믹스 |
| 2 | 전묘종 | 바람의 노래 | Nature | N/A | Auto | Wind + Harp | 바람소리 + 하프 믹스 |
| 3 | 공포 | 두꺼운 담요 | Deep Ambient | Very Slow | Auto | Low-pass Pad | 천둥 소리 차단 (먹먹하게) |
| 4 | 공포 | 심해의 고요 | Underwater | No Beat | Auto | Sub-bass | 물속에 있는 듯한 차단력 |
| 5 | 일상 | 새들의 정원 | Nature | N/A | Auto | Forest + Birds | 새소리로 외부 소음 덮기 |
| 6 | 일상 | 흐르는 시내 | Nature | N/A | Auto | Water + Flute | 물소리 + 플루트 믹스 |
| 7 | 전묘종 | 우주 방어막 | Sci-fi Ambient | Slow | Auto | Synth Pad (Smooth) | 신비로운 전자음 마스킹 |
| 8 | 전묘종 | 핑크 노이즈 | Noise | N/A | Auto | Pink Noise (Softened) | 가장 과학적인 차폐음 |

### 4. Happy Play (실내 놀이)
| No | 타겟 | 곡 제목 (Title) | AIVA Style | Tempo | Key | Instrument | 과학적 의도 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 키튼 | 우다다 타임 | Cartoon | 130 | Auto | Xylophone | 통통 튀는 실로폰 소리 |
| 2 | 키튼 | 잡아라 쥐돌이 | Classical | Fast | C Major | Strings (Pizzicato) | 현을 뜯는(Pizzicato) 소리 |
| 3 | 성묘 | 새 사냥 | Classical | Fast | Auto | Flute (Staccato) | 플루트의 빠른 연주 (새 묘사) |
| 4 | 성묘 | 점프 & 런 | Jazz (Swing) | 120 | Auto | Piano | 경쾌한 재즈 피아노 |
| 5 | 사냥 | 수풀 속으로 | Ethnic | 110 | Auto | Marimba | 나무 두드리는 마림바 소리 |
| 6 | 사냥 | 낚싯대 놀이 | Electronic | Fast | Auto | Synth Pluck | 낚싯대 흔드는 듯한 전자음 |
| 7 | 전묘종 | 캣닙 파티 | Funk (Upbeat) | 115 | Auto | Funky Bass | 엉덩이가 들썩이는 리듬 |
| 8 | 전묘종 | 궁디 팡팡 | Polka | 120 | Auto | Accordion | 뒤뚱거리는 귀여운 리듬 |

### 5. Senior Care (노령묘)
| No | 타겟 | 곡 제목 (Title) | AIVA Style | Tempo | Key | Instrument | 과학적 의도 |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 통증 | 치유의 골골송 | Drone | No Beat | Auto | 25-50Hz Boost | 강력한 햅틱 진동 (마사지) |
| 2 | 통증 | 따뜻한 찜질 | Ambient | Slow | Auto | Low Strings | 온열감을 주는 현악기 |
| 3 | 노묘 | 느린 오후 | Solo Piano | Very Slow | G Major | Piano (Sparse) | 아주 느리고 여백 많은 피아노 |
| 4 | 노묘 | 기억의 저편 | Classical | Slow | Auto | Harp | 하프의 몽환적인 선율 |
| 5 | 케어 | 영혼의 공명 | Meditation | Slow | Auto | Singing Bowl (Low) | 싱잉볼의 깊은 울림 |
| 6 | 케어 | 엄마의 심장 | Lullaby | 60 | Auto | Heartbeat FX | 어릴 적 기억 (심박수 동조) |
| 7 | 전묘종 | 고요한 쉼터 | Minimal | No Beat | Auto | Soft Pad | 아무 자극 없는 무음의 공간감 |
| 8 | 전묘종 | 편안한 호흡 | Choir | Slow | Auto | Human Voice (Soft) | 사람의 허밍 소리 (유대감) |
