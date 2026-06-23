import { Fragment, useEffect, useRef, useState } from 'react';
import {
  Box,
  Button,
  Dropdown,
  Icon,
  Section,
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
  thumb?: string;
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
  choice_value?: string;
  choice_options?: FeatureOption[];
  accessory_name?: string;
  accessory_value?: string;
  accessory_options?: FeatureOption[];
  colors?: FeatureColor[];
  extras?: FeatureExtra[];
  erp?: Booleanish;
};

type PrefsData = {
  real_name: string;
  initial_tab: string;
  tgui_theme: string;
  open_sequence: number;
  species_name: string;
  is_taur: Booleanish;
  taur_body: string;
  taur_color: string;
  taur_markings: string;
  taur_tertiary: string;
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
  underwear: string;
  underwear_color: string;
  underwear_options: FeatureOption[];
  preview_underwear: Booleanish;
  preview_clothes: Booleanish;
  preview_dir: number;
  background: string;
  background_options: FeatureOption[];
  thumbs?: Record<string, string>;
  preview_image: string | null;
  hover_sprite: string | null;
  hover_for: string | null;
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
  player_quality_color: string | null;
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

const charSections = [
  { id: 'identity', label: 'Identity', icon: 'id-card' },
  { id: 'appearance', label: 'Appearance', icon: 'palette' },
  { id: 'voice', label: 'Voice', icon: 'volume-up' },
  { id: 'background', label: 'Background', icon: 'book-open' },
  { id: 'gameplay', label: 'Gameplay', icon: 'gamepad' },
  { id: 'profile', label: 'Profile', icon: 'image' },
];

const systemSections = [
  { id: 'erp', label: 'Intimacy', icon: 'heart' },
  { id: 'settings', label: 'Settings', icon: 'cog' },
];

const TGUI_THEMES: { value: string; label: string }[] = [
  { value: 'grim', label: 'Grim' },
  { value: 'nanotrasen', label: 'Default' },
  { value: 'paper', label: 'Paper' },
  { value: 'neutral', label: 'Neutral' },
  { value: 'retro', label: 'Retro' },
  { value: 'hackerman', label: 'Hackerman' },
  { value: 'syndicate', label: 'Syndicate' },
  { value: 'wizard', label: 'Wizard' },
  { value: 'malfunction', label: 'Malfunction' },
  { value: 'cardtable', label: 'Cardtable' },
  { value: 'abductor', label: 'Abductor' },
  { value: 'ntos', label: 'NtOS' },
  { value: 'admin', label: 'Admin' },
];

const UNDERWEAR_KEY = '__underwear__';
const FACE_KEY = '__face__';
const TAUR_KEY = '__taur__';
const BACKDROP_KEY = '__backdrop__';

const FACE_PATTERNS = ['face_detail', 'eyes', 'facial_hair'];
const isFaceFeature = (key: string) =>
  FACE_PATTERNS.some((pattern) => key.includes(pattern));

const asBool = (value: Booleanish | undefined) => value === true || value === 1;

const display = (value: unknown, fallback = 'None') => {
  const text = String(value ?? '').trim();
  return text || fallback;
};

const swatchColor = (value: string) => {
  const text = String(value || '').trim();
  if (!text) {
    return '#888888';
  }
  return text.startsWith('#') ? text : `#${text}`;
};

type PanelProps = {
  title: string;
  icon?: string;
  buttons?: React.ReactNode;
  children?: React.ReactNode;
};

const Panel = (props: PanelProps) => {
  const { title, icon, buttons, children } = props;
  return (
    <Section
      mb={1}
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
      buttons={buttons}
    >
      {children}
    </Section>
  );
};

type PrefRowProps = {
  icon: string;
  label: string;
  value?: unknown;
  onClick?: () => void;
  disabled?: boolean;
  selected?: boolean;
  swatch?: string;
  tooltip?: string;
};

const PrefRow = (props: PrefRowProps) => {
  const { icon, label, value, onClick, disabled, selected, swatch, tooltip } =
    props;
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
        {swatch ? (
          <Stack.Item>
            <Box
              width="12px"
              height="12px"
              style={{ border: '1px solid rgba(0,0,0,0.6)' }}
              backgroundColor={swatchColor(swatch)}
            />
          </Stack.Item>
        ) : null}
        <Stack.Item>
          <Box bold>{display(value)}</Box>
        </Stack.Item>
      </Stack>
    </Button>
  );
};

const InfoRow = (props: {
  icon: string;
  label: string;
  value?: unknown;
  valueColor?: string;
}) => {
  const { icon, label, value, valueColor } = props;
  return (
    <Box mb={0.5} p={0.5}>
      <Stack align="center">
        <Stack.Item>
          <Icon name={icon} />
        </Stack.Item>
        <Stack.Item grow>
          <Box textAlign="left">{label}</Box>
        </Stack.Item>
        <Stack.Item>
          <Box bold color={valueColor}>
            {display(value)}
          </Box>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const ActionButton = (props: {
  icon: string;
  label: string;
  onClick?: () => void;
  color?: string;
  disabled?: boolean;
  selected?: boolean;
}) => {
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

const OptionGrid = (props: {
  options: FeatureOption[];
  selected?: string;
  onSelect: (value: string) => void;
  onHover?: (value: string | null) => void;
  thumbs?: Record<string, string>;
}) => {
  const { options, selected, onSelect, onHover, thumbs } = props;
  const thumbOf = (option: FeatureOption) =>
    option.thumb || thumbs?.[option.value];
  const hasThumbs = options.some((option) => thumbOf(option));
  return (
    <Box style={{ display: 'flex', flexWrap: 'wrap' }}>
      {options.map((option) => {
        const thumb = thumbOf(option);
        return (
          <Button
            key={option.value}
            mr={0.5}
            mb={0.5}
            tooltip={option.name}
            selected={String(selected) === String(option.value)}
            onClick={() => onSelect(option.value)}
            onMouseOver={() => onHover?.(option.value)}
            onMouseLeave={() => onHover?.(null)}
            style={
              hasThumbs
                ? { width: '66px', height: '80px', padding: '2px' }
                : undefined
            }
          >
            {hasThumbs ? (
              <Box
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  height: '50px',
                }}
              >
                {thumb ? (
                  thumb.startsWith('data:') ? (
                    <img
                      src={thumb}
                      alt=""
                      style={{
                        width: '50px',
                        height: '50px',
                        objectFit: 'contain',
                        imageRendering: 'pixelated',
                      }}
                    />
                  ) : (
                    <Box
                      className={`abel_chargen48x48 ${thumb}`}
                      style={{
                        width: '48px',
                        height: '48px',
                        imageRendering: 'pixelated',
                      }}
                    />
                  )
                ) : (
                  <Icon name="ban" color="label" />
                )}
              </Box>
            ) : null}
            <Box
              style={{
                fontSize: '9px',
                lineHeight: '1.1',
                overflow: 'hidden',
                whiteSpace: 'nowrap',
                textOverflow: 'ellipsis',
                textAlign: 'center',
              }}
            >
              {option.name}
            </Box>
          </Button>
        );
      })}
    </Box>
  );
};

const FieldBlock = (props: { label: string; children: React.ReactNode }) => (
  <Box mb={1}>
    <Box color="label" mb={0.5}>
      {props.label}
    </Box>
    {props.children}
  </Box>
);

export const PreferencesMenu = () => {
  const { act, data } = useBackend<PrefsData>();

  const mapTab = (tab: string) => (tab === 'game' ? 'settings' : 'identity');

  const [activeSection, setActiveSection] = useState(mapTab(data.initial_tab));
  const [activeFeature, setActiveFeature] = useState<string>(UNDERWEAR_KEY);
  const [hoverValue, setHoverValue] = useState<string | null>(null);
  const hoverTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    setActiveSection(mapTab(data.initial_tab));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [data.open_sequence]);

  const ageOptions = data.age_options ?? [];
  const erpEnabled = asBool(data.erp_enabled);
  const loadouts = data.loadouts ?? [];
  const backdropTile =
    data.background && data.background !== 'none'
      ? data.background_options?.find((o) => o.value === data.background)?.thumb
      : undefined;
  const hoverOverlay =
    hoverValue && data.hover_for === hoverValue ? data.hover_sprite : null;

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

  const customizerAct = (
    key: string,
    task: string,
    extra?: Record<string, unknown>,
  ) => {
    doPref('abel_customizer', undefined, {
      customizer: key,
      customizer_task: task,
      ...(extra || {}),
    });
  };

  const requestHover = (value: string | null, color?: string) => {
    if (hoverTimer.current) {
      clearTimeout(hoverTimer.current);
      hoverTimer.current = null;
    }
    setHoverValue(value);
    if (!value) {
      return;
    }
    hoverTimer.current = setTimeout(() => {
      doPref('abel_hover', undefined, { acc: value, color: color || '' });
    }, 120);
  };

  const headerMeta = [
    data.species_name,
    data.gender,
    `Slot ${display(data.default_slot, '1')}`,
  ]
    .filter(Boolean)
    .join('  /  ');

  // ---- Detail panels ----

  const renderIdentity = () => (
    <>
      <Panel title="Identity" icon="id-card">
        <PrefRow icon="signature" label="Name" value={data.real_name} onClick={() => doPref('name', 'input')} />
        <PrefRow icon="users" label="Species" value={data.species_name} onClick={() => doPref('species', 'input')} />
        <PrefRow icon="venus-mars" label="Body Type" value={data.gender} onClick={() => doPref('gender')} />
        <PrefRow icon="comment" label="Pronouns" value={data.pronouns} onClick={() => doPref('pronouns', 'input')} />
        <FieldBlock label="Age">
          <Dropdown
            width="100%"
            displayText={display(data.age)}
            selected={display(data.age)}
            options={ageOptions.map((option, index) => ({
              displayText: display(option, option),
              value: index + 1,
            }))}
            onSelected={(value) => act('set_age', { value })}
          />
        </FieldBlock>
        <PrefRow icon="leaf" label={display(data.ancestry_label, 'Ancestry')} value="Choose" onClick={() => doPref('s_tone', 'input')} />
        <PrefRow icon="hand-paper" label="Dominant Hand" value={data.domhand} onClick={() => doPref('domhand')} />
        <PrefRow icon="theater-masks" label="Quirks" value="Select" onClick={() => doPref('select_quirks')} />
      </Panel>

      <Panel title="Faith & Standing" icon="sun">
        <PrefRow icon="star" label="Patron" value={data.patron_name} onClick={() => doPref('patron', 'input')} />
        <PrefRow icon="asterisk" label="Faith" value={data.faith_name} onClick={() => doPref('faith', 'input')} />
        <InfoRow icon="award" label="Player Quality" value={data.player_quality} valueColor={data.player_quality_color || undefined} />
      </Panel>
    </>
  );

  const renderColorSwatches = (feature: FeatureEntry) => (
    <Box style={{ display: 'flex', flexWrap: 'wrap', alignItems: 'center' }}>
      {(feature.colors || []).map((color) => (
        <Button
          key={color.index}
          mr={0.5}
          tooltip={color.name}
          onClick={() =>
            customizerAct(feature.key, 'acc_color', { color_index: color.index })
          }
        >
          <Box
            inline
            width="22px"
            height="11px"
            verticalAlign="middle"
            backgroundColor={swatchColor(color.value)}
          />
        </Button>
      ))}
      <Button
        icon="undo"
        tooltip="Reset colors"
        onClick={() => customizerAct(feature.key, 'reset_colors')}
      />
    </Box>
  );

  const renderFeatureExtras = (feature: FeatureEntry) => {
    const extras = feature.extras || [];
    if (!extras.length) {
      return null;
    }

    return (
      <Box
        style={{
          display: 'flex',
          flexWrap: 'wrap',
          alignItems: 'center',
          gap: '4px 6px',
        }}
      >
        {extras.map((extra) => (
          <Box
            key={extra.task}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '4px',
            }}
          >
            <Box color="label" style={{ fontSize: '10px', lineHeight: '12px' }}>
              {extra.label}
            </Box>
            <Button
              compact
              tooltip={extra.label}
              onClick={() => customizerAct(feature.key, extra.task)}
            >
              {extra.kind === 'color' ? (
                <Box
                  inline
                  width="22px"
                  height="11px"
                  verticalAlign="middle"
                  backgroundColor={swatchColor(extra.value)}
                />
              ) : (
                display(extra.value)
              )}
            </Button>
          </Box>
        ))}
      </Box>
    );
  };

  const renderFeatureBody = (feature: FeatureEntry, skipColors?: boolean) => {
    const extraControls = renderFeatureExtras(feature);

    return (
      <>
        {!skipColors && feature.colors?.length ? (
          <FieldBlock label="Colors">{renderColorSwatches(feature)}</FieldBlock>
        ) : null}

        {feature.choice_options ? (
          <FieldBlock label="Type">
            <OptionGrid
              options={feature.choice_options}
              selected={feature.choice_value}
              onSelect={(value) =>
                doPref('abel_set_choice', undefined, {
                  key: feature.key,
                  choice_type: value,
                })
              }
            />
          </FieldBlock>
        ) : null}

        {feature.accessory_options ? (
          <Box mb={1}>
            <Stack align="center" mb={0.5}>
              <Stack.Item>
                <Box color="label">Style</Box>
              </Stack.Item>
              {extraControls ? <Stack.Item grow>{extraControls}</Stack.Item> : null}
            </Stack>
            <OptionGrid
              options={feature.accessory_options}
              selected={feature.accessory_value}
              onSelect={(value) =>
                customizerAct(feature.key, 'select_acc', { acc_type: value })
              }
              onHover={(v) =>
                requestHover(
                  v,
                  feature.colors?.[0]?.value ??
                    feature.extras?.find((e) => e.kind === 'color')?.value,
                )
              }
              thumbs={data.thumbs}
            />
          </Box>
        ) : feature.accessory_name ? (
          <Box mb={1}>
            <Stack align="center" mb={0.5}>
              <Stack.Item>
                <Box color="label">Style</Box>
              </Stack.Item>
              {extraControls ? <Stack.Item grow>{extraControls}</Stack.Item> : null}
            </Stack>
            <Box>{feature.accessory_name}</Box>
          </Box>
        ) : extraControls ? (
          <FieldBlock label="Options">{extraControls}</FieldBlock>
        ) : null}
      </>
    );
  };
  const renderFeatureEditor = (feature: FeatureEntry, showName?: boolean) => {
    const enabled = asBool(feature.enabled);
    return (
      <Box mb={1}>
        {showName || asBool(feature.can_disable) ? (
          <Stack align="center" mb={0.5}>
            {showName ? (
              <Stack.Item>
                <Box bold>{feature.name}</Box>
              </Stack.Item>
            ) : null}
            {asBool(feature.can_disable) ? (
              <Stack.Item>
                <Button
                  icon={enabled ? 'toggle-on' : 'toggle-off'}
                  selected={enabled}
                  onClick={() => customizerAct(feature.key, 'toggle_missing')}
                >
                  {enabled ? 'On' : 'Off'}
                </Button>
              </Stack.Item>
            ) : null}
          </Stack>
        ) : null}
        {enabled ? (
          renderFeatureBody(feature)
        ) : (
          <Box color="label">This feature is hidden.</Box>
        )}
      </Box>
    );
  };

  const renderTaurEditor = () => (
    <>
      <PrefRow icon="paw" label="Body" value={data.taur_body} onClick={() => doPref('abel_taur_body')} />
      <PrefRow icon="palette" label="Color" swatch={data.taur_color} value={data.taur_color} onClick={() => doPref('abel_taur_color', undefined, { which: 'base' })} />
      <PrefRow icon="palette" label="Markings" swatch={data.taur_markings} value={data.taur_markings} onClick={() => doPref('abel_taur_color', undefined, { which: 'markings' })} />
      <PrefRow icon="palette" label="Tertiary" swatch={data.taur_tertiary} value={data.taur_tertiary} onClick={() => doPref('abel_taur_color', undefined, { which: 'tertiary' })} />
    </>
  );

  const renderBackdropEditor = () => (
    <FieldBlock label="Backdrop tile">
      <OptionGrid
        options={data.background_options ?? []}
        selected={data.background}
        onSelect={(value) =>
          doPref('abel_preview_background', undefined, { bg: value })
        }
      />
    </FieldBlock>
  );

  const renderFeatureCard = (feature: FeatureEntry) => {
    const enabled = asBool(feature.enabled);
    return (
      <Section
        key={feature.key}
        mb={1}
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
        {enabled ? renderFeatureBody(feature) : null}
      </Section>
    );
  };

  const renderUnderwearEditor = () => {
    const isNude = String(data.underwear) === 'Nude';
    return (
      <>
        <FieldBlock label="Underwear">
          <OptionGrid
            options={data.underwear_options ?? []}
            selected={data.underwear}
            onSelect={(value) =>
              doPref('abel_underwear', undefined, { undie: value })
            }
            onHover={requestHover}
            thumbs={data.thumbs}
          />
        </FieldBlock>
        {!isNude ? (
          <FieldBlock label="Color">
            <Button onClick={() => doPref('abel_underwear_color')}>
              <Box
                inline
                width="22px"
                height="11px"
                verticalAlign="middle"
                backgroundColor={swatchColor(data.underwear_color)}
              />
            </Button>
          </FieldBlock>
        ) : null}
      </>
    );
  };

  const renderAppearance = () => {
    const appearanceFeatures = (data.features || []).filter(
      (feature) => !asBool(feature.erp),
    );
    const faceFeatures = appearanceFeatures.filter((feature) =>
      isFaceFeature(feature.key),
    );
    const otherFeatures = appearanceFeatures.filter(
      (feature) => !isFaceFeature(feature.key),
    );

    const featureTabs = [
      { key: UNDERWEAR_KEY, name: 'Underwear' },
      ...(faceFeatures.length ? [{ key: FACE_KEY, name: 'Face Details' }] : []),
      ...otherFeatures.map((feature) => ({
        key: feature.key,
        name: feature.name,
      })),
      ...(asBool(data.is_taur) ? [{ key: TAUR_KEY, name: 'Taur Body' }] : []),
      { key: BACKDROP_KEY, name: 'Backdrop' },
    ];
    const currentKey = featureTabs.some((tab) => tab.key === activeFeature)
      ? activeFeature
      : featureTabs[0]?.key;

    const renderEditor = () => {
      if (currentKey === UNDERWEAR_KEY) {
        return renderUnderwearEditor();
      }
      if (currentKey === BACKDROP_KEY) {
        return renderBackdropEditor();
      }
      if (currentKey === TAUR_KEY) {
        return renderTaurEditor();
      }
      if (currentKey === FACE_KEY) {
        if (!faceFeatures.length) {
          return <Box color="label">No face details for this species.</Box>;
        }
        return faceFeatures.map((feature) => (
          <Fragment key={feature.key}>
            {renderFeatureEditor(feature, true)}
          </Fragment>
        ));
      }
      const feature = otherFeatures.find((entry) => entry.key === currentKey);
      if (!feature) {
        return (
          <Box color="label">No customization available for this species.</Box>
        );
      }
      return renderFeatureEditor(feature, false);
    };

    return (
      <Panel
        title="Appearance"
        icon="palette"
        buttons={
          <Button icon="dice" onClick={() => doPref('randomiseappearanceprefs')}>
            Randomise
          </Button>
        }
      >
        <Box style={{ display: 'flex', flexWrap: 'wrap' }} mb={1}>
          {featureTabs.map((tab) => (
            <Button
              key={tab.key}
              mr={0.5}
              mb={0.5}
              selected={tab.key === currentKey}
              onClick={() => setActiveFeature(tab.key)}
            >
              {tab.name}
            </Button>
          ))}
        </Box>
        <Section>{renderEditor()}</Section>
      </Panel>
    );
  };

  const renderVoice = () => (
    <Panel title="Voice" icon="volume-up">
      <PrefRow icon="microphone" label="Voice Type" value={data.voice_type} onClick={() => doPref('voicetype', 'input')} />
      <PrefRow icon="comment-dots" label="Accent" value={data.selected_accent} onClick={() => doPref('selected_accent', 'input')} />
      <PrefRow icon="tint" label="Voice Color" swatch={data.voice_color} value={data.voice_color} onClick={() => doPref('voice', 'input')} />
    </Panel>
  );

  const renderBackground = () => (
    <>
      <Panel title="Flavour" icon="scroll">
        <PrefRow icon="align-left" label="Flavour Text" value="Edit" onClick={() => doPref('flavortext', 'input')} />
        <PrefRow icon="tags" label="Descriptors" value="Edit" onClick={() => doPref('descriptors', 'menu')} />
        <PrefRow icon="map" label="Culture" value={data.culture_name} onClick={() => doPref('culture', 'input')} />
        <PrefRow icon="utensils" label="Food Preferences" value="Edit" onClick={() => doPref('culinary', 'menu')} />
      </Panel>

      <Panel title="Relations" icon="users">
        <PrefRow icon="home" label="Family" value={data.family} onClick={() => doPref('family')} />
        <PrefRow icon="heart" label="Spouse Pref" value={data.spouse} onClick={() => doPref('setspouse')} />
        <PrefRow icon="venus-mars" label="Gender Pref" value={data.gender_pref} onClick={() => doPref('gender_choice')} />
      </Panel>

      <Panel title="OOC" icon="sticky-note">
        <PrefRow icon="sticky-note" label="OOC Notes" value="Edit" onClick={() => doPref('ooc_notes', 'input')} />
        <PrefRow icon="paperclip" label="OOC Extra" value="Edit" onClick={() => doPref('ooc_extra', 'input')} />
      </Panel>
    </>
  );

  const renderGameplay = () => (
    <>
      <Panel title="Class & Roles" icon="shield-alt">
        <PrefRow icon="briefcase" label="Class / Jobs" value={data.high_job} onClick={() => doPref('job', 'menu')} />
        <PrefRow icon="list-ol" label="Ready Order" value="Edit" onClick={() => doPref('multi', 'menu')} />
        <InfoRow icon="star" label="Special Role" value={data.special_role} />
        <ActionButton icon="user-secret" label="Special Roles" onClick={() => doPref('antag', 'menu')} />
      </Panel>

      <Panel title="Loadout" icon="shopping-bag">
        {loadouts.map((slot) => (
          <PrefRow
            key={slot.slot}
            icon="box"
            label={`Slot ${slot.slot}`}
            value={slot.name}
            onClick={() =>
              doPref('loadout_item', 'input', { loadout_number: slot.slot })
            }
          />
        ))}
      </Panel>

      <Panel title="Triumphs" icon="trophy">
        <InfoRow icon="coins" label="Balance" value={data.triumphs} />
        <ActionButton icon="shopping-bag" label="Triumph Shop" onClick={() => doPref('triumph_buy_menu')} />
      </Panel>
    </>
  );

  const renderProfile = () => (
    <Panel title="Profile Link" icon="image">
      <Box textAlign="center" mb={1}>
        {data.headshot ? (
          <img
            src={data.headshot}
            alt=""
            style={{ maxWidth: '100%', maxHeight: '320px' }}
          />
        ) : (
          <Box py={3} color="label">
            <Icon name="user" size={4} />
            <Box mt={1}>No headshot set</Box>
          </Box>
        )}
      </Box>
      <ActionButton icon="link" label="Set Headshot URL" onClick={() => doPref('headshot', 'input')} />
    </Panel>
  );

  const renderErp = () => {
    const erpFeatures = (data.features || []).filter((feature) =>
      asBool(feature.erp),
    );
    return (
      <>
        <Section mb={1}>
          <Stack align="center">
            <Stack.Item grow>
              <Box>
                Intimacy opt-in is{' '}
                <Box as="span" bold color={erpEnabled ? 'good' : 'bad'}>
                  {erpEnabled ? 'ENABLED' : 'DISABLED'}
                </Box>
                . Toggle it in{' '}
                <Button
                  inline
                  compact
                  icon="cog"
                  onClick={() => setActiveSection('settings')}
                >
                  Settings
                </Button>
                .
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="key"
                disabled={!erpEnabled}
                onClick={() => doPref('abel_erp_panel')}
              >
                Open Intimacy Panel
              </Button>
            </Stack.Item>
          </Stack>
        </Section>
        {erpFeatures.length ? (
          <Stack>
            <Stack.Item grow basis={0}>
              {erpFeatures
                .filter((_, index) => index % 2 === 0)
                .map(renderFeatureCard)}
            </Stack.Item>
            <Stack.Item grow basis={0}>
              {erpFeatures
                .filter((_, index) => index % 2 === 1)
                .map(renderFeatureCard)}
            </Stack.Item>
          </Stack>
        ) : (
          <Section>
            <Box color="label">
              No intimate customization available for this species.
            </Box>
          </Section>
        )}
      </>
    );
  };

  const renderSettings = () => {
    const game = data.game_prefs || ({} as PrefsData['game_prefs']);
    const toggle = (preference: string) => doPref(preference);

    return (
      <>
        <Panel title="Interface" icon="desktop">
          <PrefRow icon="keyboard" label="Hotkeys" value={asBool(game.hotkeys) ? 'ON' : 'OFF'} selected={asBool(game.hotkeys)} onClick={() => toggle('hotkeys')} />
          <PrefRow icon="mouse-pointer" label="Action Buttons" value={asBool(game.buttons_locked) ? 'Locked' : 'Unlocked'} selected={asBool(game.buttons_locked)} onClick={() => toggle('action_buttons')} />
          <PrefRow icon="window-restore" label="Fancy tgui" value={asBool(game.tgui_fancy) ? 'ON' : 'OFF'} selected={asBool(game.tgui_fancy)} onClick={() => toggle('tgui_fancy')} />
          <PrefRow icon="lock" label="Lock tgui Layout" value={asBool(game.tgui_lock) ? 'ON' : 'OFF'} selected={asBool(game.tgui_lock)} onClick={() => toggle('tgui_lock')} />
          <PrefRow icon="bolt" label="Window Flashing" value={asBool(game.windowflashing) ? 'ON' : 'OFF'} selected={asBool(game.windowflashing)} onClick={() => toggle('winflash')} />
        </Panel>

        <Panel title="Interface Theme" icon="palette">
          <Box style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}>
            {TGUI_THEMES.map((t) => (
              <Button
                key={t.value}
                selected={data.tgui_theme === t.value}
                onClick={() =>
                  doPref('abel_tgui_theme', undefined, { theme: t.value })
                }
              >
                {t.label}
              </Button>
            ))}
          </Box>
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
        </Panel>

        <Panel title="Intimacy & Tools" icon="sliders-h">
          <PrefRow icon="heart" label="Intimacy Opt-in (ERP)" value={erpEnabled ? 'ON' : 'OFF'} selected={erpEnabled} onClick={() => doPref('abel_erp_toggle')} />
          <ActionButton icon="toggle-on" label="Toggle Bitfields" onClick={() => doPref('toggles')} />
          <ActionButton icon="keyboard" label="Keybinds" onClick={() => doPref('keybinds', 'menu')} />
          <ActionButton icon="save" label="Save Preferences" color="blue" onClick={() => doPref('save')} />
        </Panel>
      </>
    );
  };

  const renderActiveSection = () => {
    switch (activeSection) {
      case 'appearance':
        return renderAppearance();
      case 'voice':
        return renderVoice();
      case 'background':
        return renderBackground();
      case 'gameplay':
        return renderGameplay();
      case 'profile':
        return renderProfile();
      case 'erp':
        return renderErp();
      case 'settings':
        return renderSettings();
      default:
        return renderIdentity();
    }
  };

  const NavTab = (section: { id: string; label: string; icon: string }) => (
    <Tabs.Tab
      key={section.id}
      icon={section.icon}
      selected={activeSection === section.id}
      onClick={() => setActiveSection(section.id)}
    >
      {section.label}
    </Tabs.Tab>
  );

  const FooterSummary = (props: {
    icon: string;
    label: string;
    value?: unknown;
    onClick: () => void;
  }) => (
    <Button color="transparent" onClick={props.onClick} tooltip={props.label}>
      <Stack align="center">
        <Stack.Item>
          <Icon name={props.icon} />
        </Stack.Item>
        <Stack.Item>
          <Box color="label" fontSize="10px">
            {props.label}
          </Box>
          <Box bold>{display(props.value)}</Box>
        </Stack.Item>
      </Stack>
    </Button>
  );

  return (
    <Window
      title="Character Setup"
      width={1180}
      height={760}
      theme={data.tgui_theme || 'grim'}
    >
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section>
              <Stack align="center">
                <Stack.Item grow>
                  <Box bold fontSize="18px">
                    {display(data.real_name, 'Unnamed')}
                  </Box>
                  <Box color="label">{headerMeta}</Box>
                </Stack.Item>
                <Stack.Item>
                  <Button icon="exchange-alt" onClick={() => doPref('changeslot')}>
                    Change Character
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Stack fill>
              <Stack.Item basis="190px">
                <Section fill scrollable>
                  <Tabs vertical>
                    {charSections.map(NavTab)}
                    <Box my={1} mx={1} height="1px" backgroundColor="rgba(255,255,255,0.15)" />
                    {systemSections.map(NavTab)}
                  </Tabs>
                </Section>
              </Stack.Item>

              <Stack.Item basis="320px">
                <Section fill title="Looking Glass">
                  <Stack vertical fill>
                    <Stack.Item grow>
                      <Box
                        style={{
                          position: 'relative',
                          height: '100%',
                          width: '100%',
                          ...(backdropTile
                            ? {
                                backgroundImage: `url(${backdropTile})`,
                                backgroundRepeat: 'no-repeat',
                                backgroundPosition: 'center',
                                backgroundSize: 'contain',
                                imageRendering: 'pixelated',
                              }
                            : {}),
                        }}
                      >
                        {data.preview_image ? (
                          <img
                            src={data.preview_image}
                            alt=""
                            style={{
                              position: 'absolute',
                              top: 0,
                              left: 0,
                              width: '100%',
                              height: '100%',
                              objectFit: 'contain',
                              imageRendering: 'pixelated',
                              filter: hoverValue ? 'grayscale(0.25)' : undefined,
                              opacity: hoverValue ? 0.85 : 1,
                            }}
                          />
                        ) : (
                          <Box
                            style={{
                              position: 'absolute',
                              top: 0,
                              left: 0,
                              width: '100%',
                              height: '100%',
                              display: 'flex',
                              alignItems: 'center',
                              justifyContent: 'center',
                            }}
                          >
                            <Icon name="user" size={6} color="label" />
                          </Box>
                        )}
                        {hoverOverlay ? (
                          <img
                            src={hoverOverlay}
                            alt=""
                            style={{
                              position: 'absolute',
                              top: 0,
                              left: 0,
                              width: '100%',
                              height: '100%',
                              objectFit: 'contain',
                              imageRendering: 'pixelated',
                              pointerEvents: 'none',
                            }}
                          />
                        ) : null}
                      </Box>
                    </Stack.Item>
                    <Stack.Item>
                      <Stack mb={0.5}>
                        <Stack.Item grow>
                          <Button
                            fluid
                            textAlign="center"
                            icon="arrow-left"
                            tooltip="Rotate left"
                            onClick={() => doPref('abel_preview_rotate', undefined, { rotate: 'left' })}
                          />
                        </Stack.Item>
                        <Stack.Item>
                          <Box color="label" style={{ lineHeight: '24px' }}>
                            Rotate
                          </Box>
                        </Stack.Item>
                        <Stack.Item grow>
                          <Button
                            fluid
                            textAlign="center"
                            icon="arrow-right"
                            tooltip="Rotate right"
                            onClick={() => doPref('abel_preview_rotate', undefined, { rotate: 'right' })}
                          />
                        </Stack.Item>
                      </Stack>
                      <Button
                        fluid
                        mb={0.5}
                        icon={asBool(data.preview_underwear) ? 'check-square' : 'square'}
                        selected={asBool(data.preview_underwear)}
                        onClick={() => doPref('abel_preview_layer', undefined, { layer: 'underwear' })}
                      >
                        Underwear Layer
                      </Button>
                      <Button
                        fluid
                        mb={0.5}
                        icon={asBool(data.preview_clothes) ? 'check-square' : 'square'}
                        selected={asBool(data.preview_clothes)}
                        onClick={() => doPref('abel_preview_layer', undefined, { layer: 'clothes' })}
                      >
                        Work Clothes Layer
                      </Button>
                      <Button
                        fluid
                        icon="dice"
                        onClick={() => doPref('randomiseappearanceprefs')}
                      >
                        Randomise Appearance
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>

              <Stack.Item grow basis={0}>
                <Section fill scrollable>{renderActiveSection()}</Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>

          <Stack.Item>
            <Section>
              <Stack align="center">
                <Stack.Item grow>
                  <Stack>
                    <Stack.Item>
                      <FooterSummary icon="shield-alt" label="Class" value={data.high_job} onClick={() => setActiveSection('gameplay')} />
                    </Stack.Item>
                    <Stack.Item>
                      <FooterSummary icon="shopping-bag" label="Loadout" value="Manage" onClick={() => setActiveSection('gameplay')} />
                    </Stack.Item>
                    <Stack.Item>
                      <FooterSummary icon="trophy" label="Triumphs" value={data.triumphs} onClick={() => setActiveSection('gameplay')} />
                    </Stack.Item>
                    <Stack.Item>
                      <FooterSummary icon="star" label="Special Role" value={data.special_role} onClick={() => setActiveSection('gameplay')} />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Button icon="dice" tooltip="Randomise Appearance" onClick={() => doPref('randomiseappearanceprefs')}>
                    Randomise
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button icon="undo" tooltip="Undo from save" onClick={() => doPref('load')}>
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
