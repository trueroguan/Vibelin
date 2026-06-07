import { useEffect, useMemo, useState } from 'react';
import { Icon } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Booleanish = boolean | number;

type LoadoutSlot = {
  slot: number;
  name: string;
};

type PrefsData = {
  real_name: string;
  initial_tab: string;
  open_sequence: number;
  species_name: string;
  gender: string;
  gender_short: string;
  default_slot: number;
  patron_name: string;
  faith_name: string;
  high_job: string;
  age: string;
  age_index: number;
  age_min: number;
  age_max: number;
  age_options: string[];
  pronouns: string;
  domhand: string;
  ancestry_label: string;
  erp_enabled: Booleanish;
  headshot: string | null;
  culture_name: string;
  voice_type: string;
  voice_color: string;
  selected_accent: string;
  family: string;
  gender_pref: string;
  spouse: string;
  loadouts: LoadoutSlot[];
  triumphs: number;
  special_role: string;
  player_quality: string;
  game_prefs: {
    hotkeys: Booleanish;
    buttons_locked: Booleanish;
    see_chat_non_mob: Booleanish;
    tgui_fancy: Booleanish;
    tgui_lock: Booleanish;
    windowflashing: Booleanish;
    lobby_music: Booleanish;
    hear_midis: Booleanish;
    ambientocclusion: Booleanish;
    auto_fit_viewport: Booleanish;
    widescreenpref: Booleanish;
    allow_midround_antag: Booleanish;
    pixel_size: string;
    scaling_method: string;
  };
};

const tabs = [
  { id: 'identity', label: 'Identity', icon: 'user' },
  { id: 'body', label: 'Body', icon: 'male' },
  { id: 'appearance', label: 'Appearance', icon: 'palette' },
  { id: 'lore', label: 'Lore', icon: 'book' },
  { id: 'gameplay', label: 'Gameplay', icon: 'gamepad' },
  { id: 'game', label: 'Game Prefs', icon: 'sliders-h' },
  { id: 'menu', label: 'Menu', icon: 'bars' },
  { id: 'system', label: 'System', icon: 'cog' },
];

const asBool = (value: Booleanish | undefined) => value === true || value === 1;

const display = (value: unknown, fallback = 'None') => {
  const text = String(value ?? '').trim();
  return text || fallback;
};

const preferencesMenuStyles = `
.PreferencesMenu {
  --prefs-bg: #0d1117;
  --prefs-panel: #131a23;
  --prefs-panel-soft: #17212c;
  --prefs-line: #2d3a48;
  --prefs-line-hot: #3aa6ad;
  --prefs-text: #d8e0e8;
  --prefs-muted: #8d9aaa;
  --prefs-cyan: #80e3ea;
  --prefs-gold: #d8b365;
  --prefs-green: #76d98c;
  --prefs-blue: #7fa8e6;
  height: 100%;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  background: linear-gradient(180deg, rgba(27, 38, 51, 0.96), rgba(9, 12, 17, 0.98)), var(--prefs-bg);
  color: var(--prefs-text);
  font-family: 'Segoe UI', 'Trebuchet MS', sans-serif;
}
.PreferencesMenu button {
  font: inherit;
}
.PreferencesMenu__header {
  min-height: 78px;
  display: grid;
  grid-template-columns: minmax(270px, 36%) minmax(0, 1fr);
  border-bottom: 1px solid rgba(128, 227, 234, 0.35);
  background: linear-gradient(90deg, rgba(18, 29, 39, 0.98), rgba(16, 22, 31, 0.92)), #111820;
  box-shadow: 0 1px 0 rgba(255, 255, 255, 0.04) inset;
}
.PreferencesMenu__hero {
  padding: 13px 18px 11px;
  border-right: 1px solid rgba(255, 255, 255, 0.08);
  overflow: hidden;
}
.PreferencesMenu__name {
  color: var(--prefs-cyan);
  font-size: 23px;
  font-weight: 800;
  line-height: 1.05;
  overflow: hidden;
  text-overflow: ellipsis;
  text-shadow: 0 0 12px rgba(128, 227, 234, 0.24);
  white-space: nowrap;
}
.PreferencesMenu__meta {
  margin-top: 5px;
  color: var(--prefs-muted);
  font-size: 13px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.PreferencesMenu__tabs {
  min-width: 0;
  display: grid;
  grid-template-columns: repeat(8, minmax(70px, 1fr));
}
.PreferencesMenu__tab {
  min-width: 0;
  padding: 9px 5px 7px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 5px;
  border: 0;
  border-left: 1px solid rgba(255, 255, 255, 0.07);
  background: rgba(255, 255, 255, 0.02);
  color: #aeb8c4;
  cursor: pointer;
  font-size: 11px;
  line-height: 1.05;
  text-transform: uppercase;
}
.PreferencesMenu__tab .Icon {
  color: #bac6d1;
  font-size: 18px;
}
.PreferencesMenu__tab span {
  max-width: 100%;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.PreferencesMenu__tab:hover {
  background: rgba(128, 227, 234, 0.1);
  color: #eefcff;
}
.PreferencesMenu__tab--active {
  background: linear-gradient(180deg, rgba(42, 139, 145, 0.72), rgba(25, 76, 86, 0.86)), #16323a;
  color: #f0feff;
  box-shadow: inset 0 -3px 0 var(--prefs-cyan);
}
.PreferencesMenu__tab--active .Icon {
  color: var(--prefs-cyan);
}
.PreferencesMenu__content {
  min-height: 0;
  flex: 1;
  padding: 14px;
  overflow-y: auto;
}
.PreferencesMenu__grid {
  display: grid;
  gap: 14px;
}
.PreferencesMenu__grid--two {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}
.PreferencesMenu__grid--three {
  grid-template-columns: repeat(3, minmax(0, 1fr));
}
.PreferencesMenu__panel {
  min-width: 0;
}
.PreferencesMenu__panelTitle {
  margin: 0 0 6px;
  display: flex;
  align-items: center;
  gap: 7px;
  color: #aab7c8;
  font-size: 15px;
  font-weight: 800;
  line-height: 1.1;
  text-transform: uppercase;
}
.PreferencesMenu__panelTitle .Icon {
  color: var(--prefs-gold);
}
.PreferencesMenu__panelBody {
  padding: 9px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  border: 1px solid rgba(101, 122, 143, 0.5);
  border-radius: 7px;
  background: linear-gradient(180deg, rgba(21, 30, 40, 0.96), rgba(13, 18, 26, 0.96));
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.04), 0 10px 22px rgba(0, 0, 0, 0.18);
}
.PreferencesMenu__panel--intimacy .PreferencesMenu__panelBody {
  border-color: rgba(103, 217, 199, 0.6);
  background: linear-gradient(180deg, rgba(23, 88, 85, 0.88), rgba(19, 55, 69, 0.96));
}
.PreferencesMenu__row,
.PreferencesMenu__infoRow,
.PreferencesMenu__action,
.PreferencesMenu__loadout {
  min-height: 30px;
  width: 100%;
  display: grid;
  align-items: center;
  border: 1px solid rgba(112, 132, 151, 0.65);
  border-radius: 5px;
  background: linear-gradient(180deg, rgba(28, 38, 51, 0.95), rgba(14, 20, 29, 0.95));
  color: var(--prefs-text);
  text-align: left;
}
.PreferencesMenu__row,
.PreferencesMenu__infoRow {
  grid-template-columns: 24px minmax(80px, 1fr) minmax(70px, auto);
  gap: 6px;
  padding: 4px 8px;
}
.PreferencesMenu__row {
  cursor: pointer;
}
.PreferencesMenu__row:hover,
.PreferencesMenu__action:hover,
.PreferencesMenu__loadout:hover {
  border-color: var(--prefs-line-hot);
  background: linear-gradient(180deg, rgba(35, 52, 67, 0.98), rgba(18, 29, 39, 0.98));
}
.PreferencesMenu__row:disabled,
.PreferencesMenu__action:disabled {
  cursor: not-allowed;
  opacity: 0.48;
}
.PreferencesMenu__row--selected {
  border-color: rgba(118, 217, 140, 0.78);
}
.PreferencesMenu__rowIcon {
  color: var(--prefs-gold);
  text-align: center;
}
.PreferencesMenu__rowLabel {
  min-width: 0;
  overflow: hidden;
  color: #dce5ed;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.PreferencesMenu__rowValue {
  min-width: 0;
  overflow: hidden;
  color: var(--prefs-cyan);
  font-weight: 800;
  text-align: right;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.PreferencesMenu__swatch {
  width: 12px;
  height: 12px;
  justify-self: end;
  border: 1px solid rgba(255, 255, 255, 0.5);
  border-radius: 50%;
}
.PreferencesMenu__action {
  min-height: 34px;
  grid-template-columns: 28px minmax(0, 1fr);
  gap: 6px;
  padding: 5px 10px;
  justify-items: center;
  cursor: pointer;
  text-align: center;
}
.PreferencesMenu__action span {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.PreferencesMenu__action--blue {
  border-color: rgba(90, 137, 211, 0.85);
  background: linear-gradient(180deg, rgba(45, 79, 130, 0.95), rgba(26, 48, 86, 0.95));
}
.PreferencesMenu__action--green {
  border-color: rgba(86, 186, 105, 0.85);
  background: linear-gradient(180deg, rgba(30, 93, 49, 0.95), rgba(21, 59, 35, 0.95));
}
.PreferencesMenu__action--selected {
  border-color: rgba(116, 232, 185, 0.9);
  color: #effff8;
}
.PreferencesMenu__toggleState {
  min-height: 42px;
  padding: 6px 10px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border: 1px solid rgba(126, 225, 210, 0.62);
  border-radius: 7px;
  background: rgba(6, 18, 22, 0.38);
}
.PreferencesMenu__toggleState span {
  color: #dbe8e8;
}
.PreferencesMenu__toggleState strong {
  color: var(--prefs-green);
}
.PreferencesMenu__portrait {
  width: 100%;
  aspect-ratio: 1 / 1;
  display: grid;
  place-items: center;
  overflow: hidden;
  border: 1px solid rgba(101, 122, 143, 0.6);
  border-radius: 6px;
  background: #0a0f15;
}
.PreferencesMenu__portrait img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.PreferencesMenu__portraitEmpty {
  width: 100%;
  height: 100%;
  display: grid;
  place-items: center;
  color: rgba(128, 227, 234, 0.6);
  font-size: 54px;
}
.PreferencesMenu__ageHead,
.PreferencesMenu__rangeBounds {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.PreferencesMenu__ageHead strong {
  color: var(--prefs-cyan);
}
.PreferencesMenu__rangeWrap {
  position: relative;
  height: 24px;
  display: flex;
  align-items: center;
}
.PreferencesMenu__rangeWrap::before {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  height: 5px;
  border-radius: 999px;
  background: #243242;
}
.PreferencesMenu__rangeFill {
  position: absolute;
  left: 0;
  height: 5px;
  border-radius: 999px;
  background: linear-gradient(90deg, #45d4d8, #8ce1ea);
}
.PreferencesMenu__range {
  position: relative;
  width: 100%;
  height: 24px;
  opacity: 0.92;
  cursor: pointer;
}
.PreferencesMenu__rangeBounds {
  color: var(--prefs-muted);
  font-size: 12px;
}
.PreferencesMenu__loadout {
  grid-template-columns: 54px minmax(0, 1fr);
  gap: 8px;
  padding: 6px 9px;
  cursor: pointer;
}
.PreferencesMenu__slot {
  color: #d5ba76;
  font-weight: 800;
  white-space: nowrap;
}
.PreferencesMenu__loadout strong {
  min-width: 0;
  overflow: hidden;
  color: var(--prefs-cyan);
  text-overflow: ellipsis;
  white-space: nowrap;
}
.PreferencesMenu__footer {
  min-height: 48px;
  padding: 7px 10px;
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 12px;
  align-items: center;
  border-top: 1px solid rgba(128, 227, 234, 0.24);
  background: rgba(7, 10, 15, 0.9);
}
.PreferencesMenu__footerStatus {
  min-width: 0;
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--prefs-muted);
}
.PreferencesMenu__footerStatus span {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
.PreferencesMenu__footerActions {
  display: grid;
  grid-template-columns: repeat(3, minmax(92px, 1fr));
  gap: 8px;
}
.PreferencesMenu__footerActions .PreferencesMenu__action {
  min-height: 34px;
}
@media (max-width: 820px) {
  .PreferencesMenu__header {
    grid-template-columns: 1fr;
  }
  .PreferencesMenu__hero {
    border-right: 0;
    border-bottom: 1px solid rgba(255, 255, 255, 0.07);
  }
  .PreferencesMenu__tabs {
    grid-template-columns: repeat(4, minmax(0, 1fr));
  }
  .PreferencesMenu__grid--two,
  .PreferencesMenu__grid--three {
    grid-template-columns: 1fr;
  }
  .PreferencesMenu__footer {
    grid-template-columns: 1fr;
  }
}
`;

const Panel = (props) => {
  const { title, icon, children, className = '' } = props;
  return (
    <section className={`PreferencesMenu__panel ${className}`}>
      <div className="PreferencesMenu__panelTitle">
        {icon && <Icon name={icon} />}
        <span>{title}</span>
      </div>
      <div className="PreferencesMenu__panelBody">{children}</div>
    </section>
  );
};

const PrefRow = (props) => {
  const {
    icon,
    label,
    value,
    onClick,
    disabled = false,
    selected = false,
    title,
  } = props;
  return (
    <button
      type="button"
      className={`PreferencesMenu__row${selected ? ' PreferencesMenu__row--selected' : ''}`}
      onClick={onClick}
      disabled={disabled}
      title={title || label}
    >
      <span className="PreferencesMenu__rowIcon">
        <Icon name={icon} />
      </span>
      <span className="PreferencesMenu__rowLabel">{label}</span>
      <strong className="PreferencesMenu__rowValue">{display(value)}</strong>
    </button>
  );
};

const InfoRow = (props) => {
  const { icon, label, value, swatch } = props;
  return (
    <div className="PreferencesMenu__infoRow">
      <span className="PreferencesMenu__rowIcon">
        <Icon name={icon} />
      </span>
      <span className="PreferencesMenu__rowLabel">{label}</span>
      {swatch && (
        <span
          className="PreferencesMenu__swatch"
          style={{ backgroundColor: swatch }}
        />
      )}
      <strong className="PreferencesMenu__rowValue">{display(value)}</strong>
    </div>
  );
};

const ActionButton = (props) => {
  const { icon, label, onClick, color = '', disabled = false, selected = false } = props;
  return (
    <button
      type="button"
      className={`PreferencesMenu__action ${color ? `PreferencesMenu__action--${color}` : ''}${selected ? ' PreferencesMenu__action--selected' : ''}`}
      onClick={onClick}
      disabled={disabled}
      title={label}
    >
      <Icon name={icon} />
      <span>{label}</span>
    </button>
  );
};

const LoadoutButton = (props) => {
  const { slot, name, onClick } = props;
  return (
    <button
      type="button"
      className="PreferencesMenu__loadout"
      onClick={onClick}
      title={`Edit loadout slot ${slot}`}
    >
      <span className="PreferencesMenu__slot">Slot {slot}</span>
      <strong>{display(name)}</strong>
    </button>
  );
};

const EmptyPortrait = () => (
  <div className="PreferencesMenu__portraitEmpty">
    <Icon name="user" />
  </div>
);

export const PreferencesMenu = () => {
  const { act, data } = useBackend<PrefsData>();
  const [activeTab, setActiveTab] = useState(data.initial_tab || 'identity');

  const ageOptions = data.age_options ?? [];
  const ageMin = Number(data.age_min ?? 1);
  const ageMax = Number(data.age_max ?? Math.max(1, ageOptions.length));
  const ageValue = Number(data.age_index ?? ageMin);
  const [ageDraft, setAgeDraft] = useState(ageValue);
  const erpEnabled = asBool(data.erp_enabled);
  const loadouts = data.loadouts ?? [];

  useEffect(() => {
    setAgeDraft(ageValue);
  }, [ageValue]);

  useEffect(() => {
    if (data.initial_tab) {
      setActiveTab(data.initial_tab);
    }
  }, [data.initial_tab, data.open_sequence]);

  const doPref = (preference: string, task?: string, extra?: Record<string, unknown>) => {
    act('pref', {
      preference,
      ...(task ? { task } : {}),
      ...(extra || {}),
    });
  };

  const commitAge = (value = ageDraft) => {
    act('set_age', { value });
  };

  const selectTab = (tabId: string) => {
    setActiveTab(tabId);
  };

  const progress = useMemo(() => {
    if (ageMax <= ageMin) {
      return 0;
    }
    return Math.max(0, Math.min(100, ((ageDraft - ageMin) / (ageMax - ageMin)) * 100));
  }, [ageDraft, ageMin, ageMax]);

  const ageLabel = ageOptions[Math.round(ageDraft) - 1] || data.age;

  const headerMeta = [
    data.species_name,
    data.gender,
    `Slot ${display(data.default_slot, '1')}`,
  ].filter(Boolean).join(' / ');

  const renderIdentity = () => (
    <div className="PreferencesMenu__grid PreferencesMenu__grid--three">
      <Panel title="Identity" icon="id-card">
        <PrefRow icon="signature" label="Name" value={data.real_name} onClick={() => doPref('name', 'input')} />
        <PrefRow icon="users" label="Species" value={data.species_name} onClick={() => doPref('species', 'input')} />
        <PrefRow icon="venus-mars" label="Body Type" value={data.gender} onClick={() => doPref('gender')} />
        <PrefRow icon="comment" label="Pronouns" value={data.pronouns} onClick={() => doPref('pronouns', 'input')} />
      </Panel>

      <Panel title="Faith & Class" icon="sun">
        <PrefRow icon="star" label="Patron" value={data.patron_name} onClick={() => doPref('patron', 'input')} />
        <PrefRow icon="asterisk" label="Faith" value={data.faith_name} onClick={() => doPref('faith', 'input')} />
        <PrefRow icon="briefcase" label="Class" value={data.high_job} onClick={() => doPref('job', 'menu')} />
        <InfoRow icon="award" label="Player Quality" value={data.player_quality} />
      </Panel>

      <Panel title="Portrait" icon="image">
        <div className="PreferencesMenu__portrait">
          {data.headshot ? <img src={data.headshot} alt="" /> : <EmptyPortrait />}
        </div>
        <ActionButton icon="image" label="Headshot" onClick={() => doPref('headshot', 'input')} />
      </Panel>
    </div>
  );

  const renderBody = () => (
    <div className="PreferencesMenu__grid PreferencesMenu__grid--two">
      <Panel title="Body" icon="child">
        <div className="PreferencesMenu__ageHead">
          <span>Age</span>
          <strong>{display(ageLabel)}</strong>
        </div>
        <div className="PreferencesMenu__rangeWrap">
          <div className="PreferencesMenu__rangeFill" style={{ width: `${progress}%` }} />
          <input
            className="PreferencesMenu__range"
            type="range"
            min={ageMin}
            max={ageMax}
            value={ageDraft}
            onChange={(event) => setAgeDraft(Number(event.currentTarget.value))}
            onMouseUp={() => commitAge()}
            onTouchEnd={() => commitAge()}
            onKeyUp={() => commitAge()}
          />
        </div>
        <div className="PreferencesMenu__rangeBounds">
          <span>{display(ageOptions[0], String(ageMin))}</span>
          <span>{display(ageOptions[ageOptions.length - 1], String(ageMax))}</span>
        </div>
        <PrefRow icon="hand-paper" label="Dominant Hand" value={data.domhand} onClick={() => doPref('domhand')} />
        <PrefRow icon="leaf" label={display(data.ancestry_label, 'Ancestry')} value="Choose" onClick={() => doPref('s_tone', 'input')} />
        <PrefRow icon="theater-masks" label="Quirks" value="Select" onClick={() => doPref('select_quirks')} />
      </Panel>

      <Panel title="Family Shape" icon="home">
        <PrefRow icon="users" label="Family" value={data.family} onClick={() => doPref('family')} />
        <PrefRow icon="heart" label="Spouse Pref" value={data.spouse} onClick={() => doPref('setspouse')} />
        <PrefRow icon="venus-mars" label="Gender Pref" value={data.gender_pref} onClick={() => doPref('gender_choice')} />
      </Panel>
    </div>
  );

  const renderAppearance = () => (
    <div className="PreferencesMenu__grid PreferencesMenu__grid--three">
      <Panel title="Appearance" icon="palette">
        <PrefRow icon="sliders-h" label="Features" value="Customize" onClick={() => doPref('customizers', 'menu')} />
        <PrefRow icon="image" label="Headshot" value={data.headshot ? 'Set' : 'None'} onClick={() => doPref('headshot', 'input')} />
        <PrefRow icon="dice" label="Randomise" value="Appearance" onClick={() => doPref('randomiseappearanceprefs')} />
      </Panel>

      <Panel title="Voice" icon="volume-up">
        <PrefRow icon="microphone" label="Voice Type" value={data.voice_type} onClick={() => doPref('voicetype', 'input')} />
        <PrefRow icon="comment-dots" label="Accent" value={data.selected_accent} onClick={() => doPref('selected_accent', 'input')} />
        <PrefRow icon="tint" label="Voice Color" value={data.voice_color} onClick={() => doPref('voice', 'input')} />
      </Panel>

      <Panel title="Intimacy Settings" icon="heart" className="PreferencesMenu__panel--intimacy">
        <div className="PreferencesMenu__toggleState">
          <span>Opt-in</span>
          <strong>{erpEnabled ? 'ON' : 'OFF'}</strong>
        </div>
        <ActionButton
          icon={erpEnabled ? 'toggle-on' : 'toggle-off'}
          label={erpEnabled ? 'Disable Opt-in' : 'Enable Opt-in'}
          selected={erpEnabled}
          onClick={() => doPref('abel_erp_toggle')}
        />
        <ActionButton
          icon="key"
          label="Open Intimacy Panel"
          disabled={!erpEnabled}
          onClick={() => doPref('abel_erp_panel')}
        />
      </Panel>
    </div>
  );

  const renderLore = () => (
    <div className="PreferencesMenu__grid PreferencesMenu__grid--three">
      <Panel title="Flavour" icon="book-open">
        <PrefRow icon="scroll" label="Flavour Text" value="Edit" onClick={() => doPref('flavortext', 'input')} />
        <PrefRow icon="tags" label="Descriptors" value="Edit" onClick={() => doPref('descriptors', 'menu')} />
        <PrefRow icon="map" label="Culture" value={data.culture_name} onClick={() => doPref('culture', 'input')} />
        <PrefRow icon="utensils" label="Food Preferences" value="Edit" onClick={() => doPref('culinary', 'menu')} />
      </Panel>

      <Panel title="OOC" icon="sticky-note">
        <PrefRow icon="sticky-note" label="OOC Notes" value="Edit" onClick={() => doPref('ooc_notes', 'input')} />
        <PrefRow icon="paperclip" label="OOC Extra" value="Edit" onClick={() => doPref('ooc_extra', 'input')} />
      </Panel>

      <Panel title="Voice & Family" icon="users">
        <InfoRow icon="microphone" label="Voice Type" value={data.voice_type} swatch={data.voice_color} />
        <InfoRow icon="comment-dots" label="Accent" value={data.selected_accent} />
        <InfoRow icon="home" label="Family" value={data.family} />
        <ActionButton icon="heart" label="Spouse Pref" onClick={() => doPref('setspouse')} />
      </Panel>
    </div>
  );

  const renderGameplay = () => (
    <div className="PreferencesMenu__grid PreferencesMenu__grid--three">
      <Panel title="Loadout" icon="shopping-bag">
        {loadouts.map((slot) => (
          <LoadoutButton
            key={slot.slot}
            slot={slot.slot}
            name={slot.name}
            onClick={() => doPref('loadout_item', 'input', { loadout_number: slot.slot })}
          />
        ))}
      </Panel>

      <Panel title="Triumphs" icon="trophy">
        <InfoRow icon="coins" label="Balance" value={data.triumphs} />
        <ActionButton icon="shopping-bag" label="Triumph Shop" onClick={() => doPref('triumph_buy_menu')} />
        <ActionButton icon="star" label="Special Roles" onClick={() => doPref('antag', 'menu')} />
      </Panel>

      <Panel title="Round Entry" icon="tasks">
        <InfoRow icon="star" label="Special Role" value={data.special_role} />
        <ActionButton icon="list-ol" label="Character Ready Order" onClick={() => doPref('multi', 'menu')} />
        <ActionButton icon="briefcase" label="Class Preferences" onClick={() => doPref('job', 'menu')} />
      </Panel>
    </div>
  );

  const renderGamePrefs = () => {
    const game = data.game_prefs || {};
    const toggle = (preference: string) => doPref(preference);

    return (
      <div className="PreferencesMenu__grid PreferencesMenu__grid--three">
        <Panel title="Interface" icon="desktop">
          <PrefRow icon="keyboard" label="Hotkeys" value={asBool(game.hotkeys) ? 'ON' : 'OFF'} selected={asBool(game.hotkeys)} onClick={() => toggle('hotkeys')} />
          <PrefRow icon="mouse-pointer" label="Action Buttons" value={asBool(game.buttons_locked) ? 'Locked' : 'Unlocked'} selected={asBool(game.buttons_locked)} onClick={() => toggle('action_buttons')} />
          <PrefRow icon="window-restore" label="Fancy tgui" value={asBool(game.tgui_fancy) ? 'ON' : 'OFF'} selected={asBool(game.tgui_fancy)} onClick={() => toggle('tgui_fancy')} />
          <PrefRow icon="lock" label="Lock tgui Layout" value={asBool(game.tgui_lock) ? 'ON' : 'OFF'} selected={asBool(game.tgui_lock)} onClick={() => toggle('tgui_lock')} />
          <PrefRow icon="bolt" label="Window Flashing" value={asBool(game.windowflashing) ? 'ON' : 'OFF'} selected={asBool(game.windowflashing)} onClick={() => toggle('winflash')} />
        </Panel>

        <Panel title="Display" icon="eye">
          <PrefRow icon="comments" label="See Non-mob Chat" value={asBool(game.see_chat_non_mob) ? 'ON' : 'OFF'} selected={asBool(game.see_chat_non_mob)} onClick={() => toggle('see_chat_non_mob')} />
          <PrefRow icon="sun" label="Ambient Occlusion" value={asBool(game.ambientocclusion) ? 'ON' : 'OFF'} selected={asBool(game.ambientocclusion)} onClick={() => toggle('ambientocclusion')} />
          <PrefRow icon="expand" label="Auto-fit Viewport" value={asBool(game.auto_fit_viewport) ? 'ON' : 'OFF'} selected={asBool(game.auto_fit_viewport)} onClick={() => toggle('auto_fit_viewport')} />
          <PrefRow icon="tv" label="Widescreen" value={asBool(game.widescreenpref) ? 'ON' : 'OFF'} selected={asBool(game.widescreenpref)} onClick={() => toggle('widescreenpref')} />
          <PrefRow icon="search-plus" label="Pixel Size" value={game.pixel_size} onClick={() => toggle('pixel_size')} />
          <PrefRow icon="image" label="Scaling Method" value={game.scaling_method} onClick={() => toggle('scaling_method')} />
        </Panel>

        <Panel title="Audio & Round" icon="volume-up">
          <PrefRow icon="music" label="Lobby Music" value={asBool(game.lobby_music) ? 'ON' : 'OFF'} selected={asBool(game.lobby_music)} onClick={() => toggle('lobby_music')} />
          <PrefRow icon="music" label="Admin MIDIs" value={asBool(game.hear_midis) ? 'ON' : 'OFF'} selected={asBool(game.hear_midis)} onClick={() => toggle('hear_midis')} />
          <PrefRow icon="user-secret" label="Midround Antag" value={asBool(game.allow_midround_antag) ? 'ON' : 'OFF'} selected={asBool(game.allow_midround_antag)} onClick={() => toggle('allow_midround_antag')} />
          <ActionButton icon="toggle-on" label="Toggle Bitfields" onClick={() => doPref('toggles')} />
          <ActionButton icon="keyboard" label="Keybinds" onClick={() => doPref('keybinds', 'menu')} />
          <ActionButton icon="save" label="Save Preferences" color="blue" onClick={() => doPref('save')} />
        </Panel>
      </div>
    );
  };

  const renderMenu = () => (
    <div className="PreferencesMenu__grid PreferencesMenu__grid--two">
      <Panel title="Character Menu" icon="bars">
        <ActionButton icon="list-ol" label="Character Ready Order" onClick={() => doPref('multi', 'menu')} />
        <ActionButton icon="exchange-alt" label="Change Character" onClick={() => doPref('changeslot')} />
        <ActionButton icon="dice" label="Randomise Appearance" onClick={() => doPref('randomiseappearanceprefs')} />
      </Panel>

      <Panel title="Tools" icon="wrench">
        <ActionButton icon="toggle-on" label="Toggles" onClick={() => doPref('toggles')} />
        <ActionButton icon="keyboard" label="Keybinds" onClick={() => doPref('keybinds', 'menu')} />
        <ActionButton icon="star" label="Special Roles" onClick={() => doPref('antag', 'menu')} />
      </Panel>
    </div>
  );

  const renderSystem = () => (
    <div className="PreferencesMenu__grid PreferencesMenu__grid--two">
      <Panel title="Slot" icon="save">
        <InfoRow icon="id-card" label="Current Slot" value={data.default_slot} />
        <ActionButton icon="save" label="Save Character" color="blue" onClick={() => doPref('save')} />
        <ActionButton icon="undo" label="Undo From Save" onClick={() => doPref('load')} />
      </Panel>

      <Panel title="Exit" icon="check">
        <ActionButton icon="check" label="Done" color="green" onClick={() => doPref('finished')} />
        <ActionButton icon="exchange-alt" label="Change Character" onClick={() => doPref('changeslot')} />
      </Panel>
    </div>
  );

  const renderActiveTab = () => {
    switch (activeTab) {
      case 'body':
        return renderBody();
      case 'appearance':
        return renderAppearance();
      case 'lore':
        return renderLore();
      case 'gameplay':
        return renderGameplay();
      case 'game':
        return renderGamePrefs();
      case 'menu':
        return renderMenu();
      case 'system':
        return renderSystem();
      default:
        return renderIdentity();
    }
  };

  return (
    <Window title="Preferences" width={1024} height={650}>
      <Window.Content fitted>
        <style>{preferencesMenuStyles}</style>
        <div className="PreferencesMenu">
          <header className="PreferencesMenu__header">
            <div className="PreferencesMenu__hero">
              <div className="PreferencesMenu__name">{display(data.real_name, 'Unnamed')}</div>
              <div className="PreferencesMenu__meta">{headerMeta}</div>
            </div>
            <nav className="PreferencesMenu__tabs">
              {tabs.map((tab) => (
                <button
                  type="button"
                  key={tab.id}
                  className={`PreferencesMenu__tab${activeTab === tab.id ? ' PreferencesMenu__tab--active' : ''}`}
                  onClick={() => selectTab(tab.id)}
                  title={tab.label}
                >
                  <Icon name={tab.icon} />
                  <span>{tab.label}</span>
                </button>
              ))}
            </nav>
          </header>

          <main className="PreferencesMenu__content">
            {renderActiveTab()}
          </main>

          <footer className="PreferencesMenu__footer">
            <div className="PreferencesMenu__footerStatus">
              <Icon name="id-card" />
              <span>{display(data.species_name)} / {display(data.high_job)} / Slot {display(data.default_slot, '1')}</span>
            </div>
            <div className="PreferencesMenu__footerActions">
              <ActionButton icon="undo" label="Undo" onClick={() => doPref('load')} />
              <ActionButton icon="save" label="Save" color="blue" onClick={() => doPref('save')} />
              <ActionButton icon="check" label="Done" color="green" onClick={() => doPref('finished')} />
            </div>
          </footer>
        </div>
      </Window.Content>
    </Window>
  );
};

export default PreferencesMenu;
