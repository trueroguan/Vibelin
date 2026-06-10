import { Children, useEffect, useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  Section,
  Slider,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Booleanish = boolean | number;

type LoadoutSlot = {
  slot: number;
  name: string;
};

type FeatureOption = {
  name: string;
  value: string;
};

type FeatureColor = {
  name: string;
  value: string;
  index: string;
};

type FeatureExtra = {
  task: string;
  label: string;
  kind: 'color' | 'text';
  value: string;
};

type FeatureEntry = {
  key: string;
  name: string;
  enabled: Booleanish;
  can_disable: Booleanish;
  choice_name: string;
  choice_options?: FeatureOption[];
  accessory_name?: string;
  accessory_options?: FeatureOption[];
  colors?: FeatureColor[];
  extras?: FeatureExtra[];
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
  features: FeatureEntry[];
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
  { id: 'features', label: 'Features', icon: 'user-edit' },
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

type PanelProps = {
  title: string;
  icon?: string;
  children?: React.ReactNode;
};

const Panel = (props: PanelProps) => {
  const { title, icon, children } = props;
  return (
    <Section
      title={
        <Stack align="center">
          {icon ? (
            <Stack.Item>
              <Icon name={icon} />
            </Stack.Item>
          ) : null}
          <Stack.Item>{title}</Stack.Item>
        </Stack>
      }
    >
      {children}
    </Section>
  );
};

const Columns = (props: { children?: React.ReactNode }) => (
  <Stack>
    {Children.toArray(props.children).map((child, index) => (
      <Stack.Item key={index} grow basis={0}>
        {child}
      </Stack.Item>
    ))}
  </Stack>
);

type PrefRowProps = {
  icon: string;
  label: string;
  value?: unknown;
  onClick?: () => void;
  disabled?: boolean;
  selected?: boolean;
  tooltip?: string;
};

const PrefRow = (props: PrefRowProps) => {
  const { icon, label, value, onClick, disabled, selected, tooltip } = props;
  return (
    <Button
      fluid
      mb={0.5}
      disabled={disabled}
      selected={selected}
      tooltip={tooltip || label}
      onClick={onClick}
    >
      <Stack align="center">
        <Stack.Item>
          <Icon name={icon} />
        </Stack.Item>
        <Stack.Item grow>
          <Box textAlign="left">{label}</Box>
        </Stack.Item>
        <Stack.Item>
          <Box bold>{display(value)}</Box>
        </Stack.Item>
      </Stack>
    </Button>
  );
};

type InfoRowProps = {
  icon: string;
  label: string;
  value?: unknown;
  swatch?: string;
};

const InfoRow = (props: InfoRowProps) => {
  const { icon, label, value, swatch } = props;
  return (
    <Box mb={0.5} p={0.5}>
      <Stack align="center">
        <Stack.Item>
          <Icon name={icon} />
        </Stack.Item>
        <Stack.Item grow>
          <Box textAlign="left">{label}</Box>
        </Stack.Item>
        {swatch ? (
          <Stack.Item>
            <Box width="12px" height="12px" backgroundColor={swatch} />
          </Stack.Item>
        ) : null}
        <Stack.Item>
          <Box bold>{display(value)}</Box>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

type ActionButtonProps = {
  icon: string;
  label: string;
  onClick?: () => void;
  color?: string;
  disabled?: boolean;
  selected?: boolean;
};

const ActionButton = (props: ActionButtonProps) => {
  const { icon, label, onClick, color, disabled, selected } = props;
  return (
    <Button
      fluid
      mb={0.5}
      textAlign="center"
      icon={icon}
      color={color || undefined}
      disabled={disabled}
      selected={selected}
      tooltip={label}
      onClick={onClick}
    >
      {label}
    </Button>
  );
};

type LoadoutButtonProps = {
  slot: number;
  name: string;
  onClick?: () => void;
};

const LoadoutButton = (props: LoadoutButtonProps) => {
  const { slot, name, onClick } = props;
  return (
    <Button
      fluid
      mb={0.5}
      tooltip={`Edit loadout slot ${slot}`}
      onClick={onClick}
    >
      <Stack align="center">
        <Stack.Item grow>
          <Box textAlign="left">Slot {slot}</Box>
        </Stack.Item>
        <Stack.Item>
          <Box bold>{display(name)}</Box>
        </Stack.Item>
      </Stack>
    </Button>
  );
};

const EmptyPortrait = () => (
  <Box textAlign="center" py={3}>
    <Icon name="user" size={4} />
  </Box>
);

export const PreferencesMenu = () => {
  const { act, data } = useBackend<PrefsData>();
  const [activeTab, setActiveTab] = useState(data.initial_tab || 'identity');

  const ageOptions = data.age_options ?? [];
  const ageMin = Number(data.age_min ?? 1);
  const ageMax = Number(data.age_max ?? Math.max(1, ageOptions.length));
  const ageValue = Number(data.age_index ?? ageMin);
  const erpEnabled = asBool(data.erp_enabled);
  const loadouts = data.loadouts ?? [];

  useEffect(() => {
    if (data.initial_tab) {
      setActiveTab(data.initial_tab);
    }
  }, [data.initial_tab, data.open_sequence]);

  const doPref = (
    preference: string,
    task?: string,
    extra?: Record<string, unknown>,
  ) => {
    act('pref', {
      preference,
      ...(task ? { task } : {}),
      ...(extra || {}),
    });
  };

  const commitAge = (value: number) => {
    act('set_age', { value });
  };

  const selectTab = (tabId: string) => {
    setActiveTab(tabId);
  };

  const headerMeta = [data.species_name, data.gender, `Slot ${display(data.default_slot, '1')}`]
    .filter(Boolean)
    .join(' / ');

  const renderIdentity = () => (
    <Columns>
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
        <Box textAlign="center" mb={1}>
          {data.headshot ? (
            <img src={data.headshot} alt="" style={{ maxWidth: '100%' }} />
          ) : (
            <EmptyPortrait />
          )}
        </Box>
        <ActionButton icon="image" label="Headshot" onClick={() => doPref('headshot', 'input')} />
      </Panel>
    </Columns>
  );

  const renderBody = () => (
    <Columns>
      <Panel title="Body" icon="child">
        <Stack align="center" mb={1}>
          <Stack.Item grow>
            <Box bold>Age</Box>
          </Stack.Item>
          <Stack.Item>
            <Box>{display(data.age)}</Box>
          </Stack.Item>
        </Stack>
        <Slider
          mb={1}
          value={ageValue}
          minValue={ageMin}
          maxValue={ageMax}
          step={1}
          format={(value) => display(ageOptions[Math.round(value) - 1], data.age)}
          onChange={(_event, value) => commitAge(value)}
        />
        <PrefRow icon="hand-paper" label="Dominant Hand" value={data.domhand} onClick={() => doPref('domhand')} />
        <PrefRow icon="leaf" label={display(data.ancestry_label, 'Ancestry')} value="Choose" onClick={() => doPref('s_tone', 'input')} />
        <PrefRow icon="theater-masks" label="Quirks" value="Select" onClick={() => doPref('select_quirks')} />
      </Panel>

      <Panel title="Family Shape" icon="home">
        <PrefRow icon="users" label="Family" value={data.family} onClick={() => doPref('family')} />
        <PrefRow icon="heart" label="Spouse Pref" value={data.spouse} onClick={() => doPref('setspouse')} />
        <PrefRow icon="venus-mars" label="Gender Pref" value={data.gender_pref} onClick={() => doPref('gender_choice')} />
      </Panel>
    </Columns>
  );

  const renderAppearance = () => (
    <Columns>
      <Panel title="Appearance" icon="palette">
        <PrefRow icon="sliders-h" label="Features" value="Customize" onClick={() => selectTab('features')} />
        <PrefRow icon="image" label="Headshot" value={data.headshot ? 'Set' : 'None'} onClick={() => doPref('headshot', 'input')} />
        <PrefRow icon="dice" label="Randomise" value="Appearance" onClick={() => doPref('randomiseappearanceprefs')} />
      </Panel>

      <Panel title="Voice" icon="volume-up">
        <PrefRow icon="microphone" label="Voice Type" value={data.voice_type} onClick={() => doPref('voicetype', 'input')} />
        <PrefRow icon="comment-dots" label="Accent" value={data.selected_accent} onClick={() => doPref('selected_accent', 'input')} />
        <PrefRow icon="tint" label="Voice Color" value={data.voice_color} onClick={() => doPref('voice', 'input')} />
      </Panel>

      <Panel title="Intimacy Settings" icon="heart">
        <Stack align="center" mb={1}>
          <Stack.Item grow>
            <Box bold>Opt-in</Box>
          </Stack.Item>
          <Stack.Item>
            <Box bold>{erpEnabled ? 'ON' : 'OFF'}</Box>
          </Stack.Item>
        </Stack>
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
    </Columns>
  );

  const customizerAct = (key: string, task: string, extra?: Record<string, unknown>) => {
    doPref('abel_customizer', undefined, {
      customizer: key,
      customizer_task: task,
      ...(extra || {}),
    });
  };

  const swatchColor = (value: string) => {
    const text = String(value || '').trim();
    if (!text) {
      return '#888888';
    }
    return text.startsWith('#') ? text : `#${text}`;
  };

  const renderFeatureRow = (label: string, control: React.ReactNode) => (
    <Stack align="center" mb={0.5}>
      <Stack.Item grow>
        <Box color="label">{label}</Box>
      </Stack.Item>
      <Stack.Item>{control}</Stack.Item>
    </Stack>
  );

  const renderSwatchButton = (value: string, onClick: () => void) => (
    <Button onClick={onClick}>
      <Box
        inline
        width="24px"
        height="11px"
        verticalAlign="middle"
        backgroundColor={swatchColor(value)}
      />
    </Button>
  );

  const renderFeature = (feature: FeatureEntry) => {
    const enabled = asBool(feature.enabled);
    return (
      <Section
        key={feature.key}
        title={feature.name}
        buttons={
          asBool(feature.can_disable) ? (
            <Button
              icon={enabled ? 'toggle-on' : 'toggle-off'}
              selected={enabled}
              onClick={() => customizerAct(feature.key, 'toggle_missing')}
            >
              {enabled ? 'On' : 'Off'}
            </Button>
          ) : null
        }
      >
        {enabled && (
          <>
            {feature.choice_options ? (
              renderFeatureRow(
                'Type',
                <Dropdown
                  width="180px"
                  displayText={feature.choice_name}
                  selected={null}
                  options={feature.choice_options.map((option) => ({
                    displayText: option.name,
                    value: option.value,
                  }))}
                  onSelected={(value) =>
                    doPref('abel_set_choice', undefined, {
                      key: feature.key,
                      choice_type: value,
                    })
                  }
                />,
              )
            ) : null}
            {feature.accessory_name ? (
              feature.accessory_options ? (
                renderFeatureRow(
                  'Style',
                  <Dropdown
                    width="180px"
                    buttons
                    displayText={feature.accessory_name}
                    selected={null}
                    options={feature.accessory_options.map((option) => ({
                      displayText: option.name,
                      value: option.value,
                    }))}
                    onSelected={(value) =>
                      customizerAct(feature.key, 'select_acc', { acc_type: value })
                    }
                  />,
                )
              ) : (
                renderFeatureRow('Style', <Box>{feature.accessory_name}</Box>)
              )
            ) : null}
            {(feature.colors || []).map((color) =>
              renderFeatureRow(
                color.name,
                renderSwatchButton(color.value, () =>
                  customizerAct(feature.key, 'acc_color', { color_index: color.index }),
                ),
              ),
            )}
            {feature.colors?.length ? (
              <Button
                icon="undo"
                mb={0.5}
                onClick={() => customizerAct(feature.key, 'reset_colors')}
              >
                Reset Colors
              </Button>
            ) : null}
            {(feature.extras || []).map((extra) =>
              renderFeatureRow(
                extra.label,
                extra.kind === 'color' ? (
                  renderSwatchButton(extra.value, () =>
                    customizerAct(feature.key, extra.task),
                  )
                ) : (
                  <Button onClick={() => customizerAct(feature.key, extra.task)}>
                    {display(extra.value)}
                  </Button>
                ),
              ),
            )}
          </>
        )}
      </Section>
    );
  };

  const renderFeatures = () => {
    const features = data.features || [];
    if (!features.length) {
      return (
        <Section>
          <Box color="label">No customization available for this species.</Box>
        </Section>
      );
    }
    const left = features.filter((_, index) => index % 2 === 0);
    const right = features.filter((_, index) => index % 2 === 1);
    return (
      <Stack>
        <Stack.Item grow basis={0}>
          {left.map(renderFeature)}
        </Stack.Item>
        <Stack.Item grow basis={0}>
          {right.map(renderFeature)}
        </Stack.Item>
      </Stack>
    );
  };

  const renderLore = () => (
    <Columns>
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
    </Columns>
  );

  const renderGameplay = () => (
    <Columns>
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
    </Columns>
  );

  const renderGamePrefs = () => {
    const game = data.game_prefs || ({} as PrefsData['game_prefs']);
    const toggle = (preference: string) => doPref(preference);

    return (
      <Columns>
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
      </Columns>
    );
  };

  const renderMenu = () => (
    <Columns>
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
    </Columns>
  );

  const renderSystem = () => (
    <Columns>
      <Panel title="Slot" icon="save">
        <InfoRow icon="id-card" label="Current Slot" value={data.default_slot} />
        <ActionButton icon="save" label="Save Character" color="blue" onClick={() => doPref('save')} />
        <ActionButton icon="undo" label="Undo From Save" onClick={() => doPref('load')} />
      </Panel>

      <Panel title="Exit" icon="check">
        <ActionButton icon="check" label="Done" color="green" onClick={() => doPref('finished')} />
        <ActionButton icon="exchange-alt" label="Change Character" onClick={() => doPref('changeslot')} />
      </Panel>
    </Columns>
  );

  const renderActiveTab = () => {
    switch (activeTab) {
      case 'body':
        return renderBody();
      case 'appearance':
        return renderAppearance();
      case 'features':
        return renderFeatures();
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
    <Window title="Preferences" width={1024} height={650} theme="grim">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section>
              <Box bold fontSize="18px">
                {display(data.real_name, 'Unnamed')}
              </Box>
              <Box color="label">{headerMeta}</Box>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Tabs fluid>
              {tabs.map((tab) => (
                <Tabs.Tab
                  key={tab.id}
                  icon={tab.icon}
                  selected={activeTab === tab.id}
                  onClick={() => selectTab(tab.id)}
                >
                  {tab.label}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>

          <Stack.Item grow basis={0}>
            <Box height="100%" style={{ overflowY: 'auto' }}>
              {renderActiveTab()}
            </Box>
          </Stack.Item>

          <Stack.Item>
            <Section>
              <Stack align="center">
                <Stack.Item grow>
                  <Icon name="id-card" mr={1} />
                  {display(data.species_name)} / {display(data.high_job)} / Slot{' '}
                  {display(data.default_slot, '1')}
                </Stack.Item>
                <Stack.Item>
                  <Button icon="undo" tooltip="Undo" onClick={() => doPref('load')}>
                    Undo
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button icon="save" color="blue" tooltip="Save" onClick={() => doPref('save')}>
                    Save
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button icon="check" color="green" tooltip="Done" onClick={() => doPref('finished')}>
                    Done
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export default PreferencesMenu;
