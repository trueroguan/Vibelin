import { useBackend } from './backend';

export type Lang = 'ru' | 'en';

/**
 * Chrome strings (buttons, tabs, labels): authored in both languages here,
 * because they have no server-provided source to fall back to.
 */
export type ChromeEntry = { ru: string; en: string };
export type ChromeDict = Record<string, ChromeEntry>;

/**
 * Content strings (names authored in DM, e.g. action/kink/organ names):
 * only the English override lives here. The Russian value is the name the
 * server already sends, so it is never duplicated and can never desync.
 */
export type ContentDict = Record<string, string>;

export function useLang(): Lang {
  const { data } = useBackend<{ lang?: Lang }>();
  return data?.lang === 'en' ? 'en' : 'ru';
}

export type Translator = {
  lang: Lang;
  /** Translate a chrome key. Falls back to the provided text, then the key. */
  t: (key: string, fallback?: string) => string;
  /** Translate a DM-provided content name by its stable id. RU keeps dmName. */
  tc: (id: string | null | undefined, dmName: string) => string;
};

export function makeTranslator(
  lang: Lang,
  chrome: ChromeDict,
  content?: ContentDict,
): Translator {
  return {
    lang,
    t: (key, fallback) => {
      const entry = chrome[key];
      if (!entry) {
        return fallback ?? key;
      }
      return entry[lang] ?? entry.ru ?? fallback ?? key;
    },
    tc: (id, dmName) => {
      if (lang !== 'en' || !content || !id) {
        return dmName;
      }
      return content[id] ?? dmName;
    },
  };
}

export function useTranslator(
  chrome: ChromeDict,
  content?: ContentDict,
): Translator {
  const lang = useLang();
  return makeTranslator(lang, chrome, content);
}
