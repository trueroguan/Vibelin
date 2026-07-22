import { useBackend } from './backend';

export type Lang = 'ru' | 'en';

export type ChromeEntry = { ru: string; en: string };
export type ChromeDict = Record<string, ChromeEntry>;

export type ContentDict = Record<string, string>;

export function useLang(): Lang {
  const { data } = useBackend<{ lang?: Lang }>();
  return data?.lang === 'en' ? 'en' : 'ru';
}

export type Translator = {
  lang: Lang;
  t: (key: string, fallback?: string) => string;
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
