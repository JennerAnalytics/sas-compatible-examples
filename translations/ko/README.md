# SAS 호환 예제 모음 (Jenner)

🌐 [English](../../README.md) · [Čeština](../cs/README.md) · [Dansk](../da/README.md) · [Deutsch](../de/README.md) · [Ελληνικά](../el/README.md) · [Español](../es/README.md) · [Suomi](../fi/README.md) · [Français](../fr/README.md) · [Italiano](../it/README.md) · [日本語](../ja/README.md) · [Nederlands](../nl/README.md) · [Polski](../pl/README.md) · [Português](../pt/README.md) · [Svenska](../sv/README.md) · [中文](../zh/README.md)

[Jenner](https://jenneranalytics.com)(SAS 호환 DATA 스텝·PROC 엔진)에서 실행되는,
엄선되고 **검증된** 분석 예제 노트북 모음입니다.

여기에 게시된 각 노트북은 단순히 실행 여부만 확인한 것이 아니라 **내용의
진실성에 대해 검토**되었습니다:

- Jenner의 Jupyter 커널에서 오류 없이 실행되며, **실행된 출력(표와 그래프)이
  포함되어 있습니다** — 다운로드하거나 다시 실행하지 않고 GitHub에서 바로
  결과를 읽을 수 있습니다.
- 서술의 모든 숫자와 결론은 **노트북의 실제 출력에 근거합니다** — 미리 작성되거나
  조작된 결과가 없습니다.
- 생성된 모든 이미지는 **육안으로 검토**되었습니다.
- 제목에 명시된 SAS 프로시저가 실제로 실행되는 프로시저와 일치합니다.

이 기준을 충족하지 못한 노트북은 게시하지 않고 제외했습니다. 의도적으로 작고
신뢰도 높은 모음이며, 더 많은 예제가 검토를 통과할 때마다 확장됩니다.

## 한국어 노트북

이 디렉터리에는 노트북의 한국어 버전이 들어 있습니다. markdown 서술**과**
코드 키워드가 모두 번역되어 있습니다(`데이터`, `설정`, `실행` 등). Jenner는
이 프로그램을 그대로 실행합니다 — 엔진이 언어를 자동으로 감지합니다. 변수
이름과 데이터 값은 포함된 출력과 일치하도록 변경하지 않았습니다.

- `procs/<프로시저>/<주제>/` — SAS 프로시저별로 구성된 예제.
- `<산업>/<주제>/` — 업무 도메인별로 구성된 예제.

## 예제 실행 방법

```bash
jenner jupyter install
jupyter lab
```

**Jenner** 커널을 선택하고 "Run All"을 실행하세요. 출력이 이미 포함되어 있으므로
노트북을 그대로 읽기만 해도 됩니다.

## 프로그램 번역

프로그램이나 노트북을 언어 간에(양방향으로) 변환하려면
[`tools/translate.py`](../../tools/README.md)를 사용하세요:

```bash
python3 tools/translate.py --to ko program.jenner   # 영어 → 한국어
python3 tools/translate.py --to en program.jenner   # 한국어 → 영어
```
