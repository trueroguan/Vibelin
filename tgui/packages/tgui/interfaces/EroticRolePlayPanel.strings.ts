import type { ChromeDict, ContentDict } from '../i18n';
import { useTranslator } from '../i18n';

/**
 * Interface chrome — buttons, tabs, labels, section titles. Authored in both
 * languages because there is no server-provided source to fall back to.
 */
export const ERP_CHROME: ChromeDict = {
  'window.title': { ru: 'Утолить Желания', en: 'Sate Desires' },

  'control.arouse': { ru: 'ВОЗБУЖДАТЬСЯ', en: 'AROUSE' },
  'control.yield': { ru: 'ПОДДАВАТЬСЯ', en: 'YIELD' },
  'control.moan': { ru: 'СТОНАТЬ', en: 'MOAN' },
  'control.hidden': { ru: 'СКРЫТНО', en: 'DISCREET' },
  'control.flip': { ru: 'ПЕРЕВЕРНУТЬСЯ', en: 'FLIP OVER' },
  'control.stop': { ru: 'ОСТАНОВИТЬСЯ', en: 'STOP' },

  'bar.me': { ru: 'Я', en: 'Me' },
  'bar.partner': { ru: 'Партнёр', en: 'Partner' },

  'tab.actions': { ru: 'ДЕЙСТВИЯ', en: 'ACTIONS' },
  'tab.status': { ru: 'СТАТУС', en: 'STATUS' },
  'tab.erp': { ru: 'ЭРП', en: 'ERP' },
  'tab.editor': { ru: 'РЕДАКТОР', en: 'EDITOR' },

  'base_tuning.title': {
    ru: 'Базовые настройки новых действий',
    en: 'Defaults for new actions',
  },
  'label.speed': { ru: 'Скорость', en: 'Speed' },
  'label.force': { ru: 'Сила', en: 'Force' },

  'speed.0': { ru: 'Медленно', en: 'Slow' },
  'speed.1': { ru: 'Средне', en: 'Medium' },
  'speed.2': { ru: 'Быстро', en: 'Fast' },
  'speed.3': { ru: 'Неистово', en: 'Frantic' },
  'force.0': { ru: 'Нежно', en: 'Gentle' },
  'force.1': { ru: 'Уверенно', en: 'Firm' },
  'force.2': { ru: 'Сильно', en: 'Hard' },
  'force.3': { ru: 'Жестко', en: 'Rough' },

  'actions.title': { ru: 'Действия', en: 'Actions' },
  'actions.empty': { ru: 'Нет доступных действий.', en: 'No available actions.' },
  'nodes.me': { ru: 'Я', en: 'Me' },
  'nodes.partner': { ru: 'Партнёр', en: 'Partner' },

  'links.title': { ru: 'Активные связки', en: 'Active links' },
  'links.stop_tooltip': { ru: 'Остановить связку', en: 'Stop link' },
  'links.default_action': { ru: 'ДЕЙСТВИЕ', en: 'ACTION' },
  'links.toggle_finish_tooltip': {
    ru: 'Переключить режим завершения',
    en: 'Toggle finish mode',
  },
  'links.until_climax': { ru: 'ДО КЛИМАКСА', en: 'UNTIL CLIMAX' },
  'links.until_stop': { ru: 'ПОКА НЕ ОСТАНОВЛЮСЬ', en: 'UNTIL I STOP' },

  'penis.title': { ru: 'Настройки члена', en: 'Penis settings' },
  'penis.knot': { ru: 'Узел', en: 'Knot' },
  'penis.knot_on': { ru: 'ДО УЗЛА', en: 'WITH KNOT' },
  'penis.knot_off': { ru: 'БЕЗ УЗЛА', en: 'NO KNOT' },
  'penis.where_climax': { ru: 'Куда кончить', en: 'Where to finish' },

  'filter.title': { ru: 'Фильтр', en: 'Filter' },
  'filter.placeholder': {
    ru: 'Поиск взаимодействия...',
    en: 'Search interaction...',
  },

  'pref.dislike': { ru: 'Не нравится', en: 'Dislike' },
  'pref.like': { ru: 'Нравится', en: 'Like' },
  'pref.neutral': { ru: 'Нейтрально', en: 'Neutral' },

  'organ.fallback_name': { ru: 'Орган', en: 'Organ' },
  'organ.active': { ru: 'активен', en: 'active' },
  'organ.sensitivity': { ru: 'Чувств.:', en: 'Sens.:' },
  'organ.pain': { ru: 'Боль:', en: 'Pain:' },
  'organ.overflow': { ru: 'ПЕРЕПОЛН.', en: 'OVERFLOW' },
  'organ.arousal': { ru: 'Возбуждение', en: 'Arousal' },
  'erect.auto': { ru: 'АВТО', en: 'AUTO' },
  'erect.none': { ru: 'МЯГКИЙ', en: 'SOFT' },
  'erect.partial': { ru: 'ВОЗБУЖДЕН', en: 'AROUSED' },
  'erect.hard': { ru: 'КРЕПКИЙ', en: 'HARD' },
  'organ.fill': { ru: 'Наполненность:', en: 'Fullness:' },
  'organ.passive_links': { ru: 'Воздействия на орган', en: 'Acting on organ' },
  'organ.active_links': { ru: 'Орган воздействует', en: 'Organ acts' },

  'arousal.charge': { ru: 'Заряд:', en: 'Charge:' },
  'arousal.for_orgasm': { ru: 'для оргазма', en: 'for orgasm' },
  'arousal.wellbeing': { ru: 'Самочувствие:', en: 'Wellbeing:' },
  'arousal.normal': { ru: 'нормально', en: 'normal' },
  'arousal.overstim': { ru: 'СВЕРХ-СТИМУЛЯЦИЯ', en: 'OVERSTIMULATION' },

  'status.title': { ru: 'Статус', en: 'Status' },
  'status.empty': { ru: 'Пусто (entries не пришли)', en: 'Empty (no entries)' },

  'bool.on': { ru: 'ВКЛ', en: 'ON' },
  'bool.off': { ru: 'ВЫКЛ', en: 'OFF' },

  'list.add_placeholder': { ru: 'добавить...', en: 'add...' },
  'section.params': { ru: 'Параметры', en: 'Parameters' },

  'editor.title': { ru: 'Редактор действий', en: 'Action editor' },
  'editor.templates': { ru: 'Шаблоны', en: 'Templates' },
  'editor.no_templates': {
    ru: 'Нет доступных шаблонов.',
    en: 'No available templates.',
  },
  'editor.my_custom': { ru: 'Мои кастомные', en: 'My custom' },
  'editor.empty_custom': { ru: 'Пока пусто.', en: 'Empty for now.' },
  'editor.pick_hint': {
    ru: 'Выбери слева шаблон или своё действие.',
    en: 'Pick a template or your action on the left.',
  },
  'editor.basic': { ru: 'Основное', en: 'Basic' },
  'editor.name': { ru: 'Название', en: 'Name' },
  'editor.fields': { ru: 'Поля', en: 'Fields' },
  'editor.no_fields': {
    ru: 'Поля не пришли (или backend ещё не отдал выбранное действие полностью).',
    en: "Fields not received (backend hasn't fully sent the selected action).",
  },
  'editor.raw_hint': {
    ru: 'В RAW можно править payload полей. Если JSON сломан — уйдёт обычный вариант.',
    en: 'In RAW you can edit the fields payload. If the JSON is broken, the normal variant is sent.',
  },
  'editor.create': { ru: 'СОЗДАТЬ КАСТОМ', en: 'CREATE CUSTOM' },
  'editor.save': { ru: 'СОХРАНИТЬ', en: 'SAVE' },
  'editor.delete': { ru: 'УДАЛИТЬ', en: 'DELETE' },
  'editor.dirty_hint': {
    ru: 'Локальные правки не будут перезатираться обновлениями UI до сохранения или смены выбора.',
    en: "Local edits won't be overwritten by UI updates until you save or change the selection.",
  },

  'kinks.title': { ru: 'Фетиши', en: 'Fetishes' },
  'kinks.search_placeholder': { ru: 'Поиск по кинкам...', en: 'Search kinks...' },
  'kinks.settings': { ru: 'Настройки', en: 'Settings' },
  'kinks.no_results': {
    ru: 'Ничего не найдено по фильтрам.',
    en: 'Nothing found for the filters.',
  },
  'kinks.cat_all': { ru: 'ВСЕ', en: 'ALL' },

  'tab.placeholder': { ru: 'Контент вкладки позже.', en: 'Tab content later.' },
  'modal.set_arousal': {
    ru: 'Установить возбуждение (0–100)',
    en: 'Set arousal (0–100)',
  },
  'modal.set_sensitivity': {
    ru: 'Чувствительность (например 0–2)',
    en: 'Sensitivity (e.g. 0–2)',
  },
  'btn.cancel': { ru: 'Отмена', en: 'Cancel' },
};

/**
 * Content names authored in DM (organ categories, climax modes, action names).
 * Only the English override is stored here, keyed by the stable id the server
 * sends (organ type token, climax-mode id, or action typepath). The Russian
 * value is the name the server already sends, so it is never duplicated.
 * Missing keys fall back to the server name, so an incomplete map never breaks.
 */
export const ERP_CONTENT: ContentDict = {
  // organ categories (SEX_ORGAN_* tokens)
  hands: 'Hands',
  legs: 'Legs',
  tail: 'Tail',
  mouth: 'Mouth',
  anus: 'Anus',
  breasts: 'Breasts',
  vagina: 'Vagina',
  penis: 'Penis',
  body: 'Body',

  // climax modes
  outside: 'Outside',
  inside: 'Inside',

  // action names (keyed by typepath — seed set; the rest fall back to Russian)
  '/datum/erp_action/other/mouth/kiss': 'Kiss',
};

export function useErpTranslator() {
  return useTranslator(ERP_CHROME, ERP_CONTENT);
}
