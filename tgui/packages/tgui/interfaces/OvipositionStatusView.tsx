import { type ReactNode, useState } from 'react';
import {
  Box,
  Button,
  Icon,
  NumberInput,
  ProgressBar,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type EggOption = {
  id: string;
  name: string;
};

type TraitOption = {
  id: string;
  name: string;
};

type ColorPreset = {
  id: string;
  name: string;
  color: string;
};

type EggData = {
  ref: string;
  name: string;
  desc?: string;
  type_name: string;
  display_color: string | null;
  color_hex: string | null;
  has_preg: boolean;
  stage: number;
  max_stage: number;
  progress_pct: number;
  scale?: number;
  traits?: string[];
  can_remove?: boolean;
  is_hatchling?: boolean;
  fertilized?: boolean;
  hatch_inside?: boolean;
  auto_hatch?: boolean;
  mother_name?: string;
  father_name?: string;
  status: string;
  time_left: number;
};

type OrganSettings = {
  can_configure?: boolean;
  egg_type: string;
  egg_type_name: string;
  clutch_size: number;
  capacity: number;
  max_capacity?: number;
  max_clutch: number;
  custom_name?: string;
  custom_desc?: string;
  custom_organ_desc?: string;
  custom_color?: string | null;
  auto_hatch?: boolean | null;
  resource_dependent?: boolean;
  egg_scale: number;
  egg_traits?: string[];
  available_egg_types: EggOption[];
  available_traits: TraitOption[];
  color_presets: ColorPreset[];
  nutrient_cost?: number;
};

type OrganData = {
  id: string;
  title: string;
  icon: string;
  egg_count: number;
  eggs: EggData[];
  settings?: OrganSettings;
  egg_capacity?: number;
  clutch_size?: number;
  egg_type_name?: string;
  custom_color?: string | null;
  custom_name?: string;
  resource_dependent?: boolean;
  egg_stage?: number;
  is_egg_layer?: boolean;
  hatchling_count?: number;
  next_egg_seconds?: number;
  interval_seconds?: number;
};

type StatusData = {
  nutriment: number;
  organs: OrganData[];
};

type ActiveTab = 'eggs' | 'settings' | 'genetics';

export type OvipositionStatusLocale = {
  windowTitle: string;
  emptyState: string;
  tabs: Record<ActiveTab, string>;
  labels: {
    organ: string;
    eggsInside: string;
    stored: string;
    clutch: string;
    capacity: string;
    color: string;
    type: string;
    name: string;
    description: string;
    organDescription: string;
    nutrients: string;
    nutrientCost: string;
    interval: string;
    resourceDependent: string;
    limit: string;
    production: string;
    nextEgg: string;
    hatchlingsInside: string;
    stage: string;
    scale: string;
    traits: string;
    preview: string;
    parents: string;
    mother: string;
    father: string;
    unknown: string;
    defaultColor: string;
    fertilized: string;
    unfertilized: string;
    by: string;
    autoHatch: string;
    internalBirth: string;
    willHatchInside: string;
    extract: string;
    extractAll: string;
    layEggs: string;
    edit: string;
    pickColor: string;
    apply: string;
    reset: string;
    profileDefault: string;
    on: string;
    off: string;
    active: string;
    inactive: string;
    yes: string;
    no: string;
    unknownStage: string;
  };
  organNames: Record<string, string>;
  eggTypes: Record<string, string>;
  traitNames: Record<string, string>;
  formatTime: (seconds: number) => string;
  formatStatus: (status: string, timeLeft: number) => string;
};

const statusColor = (status: string): string => {
  if (status === 'ready') {
    return 'good';
  }
  if (status === 'growing') {
    return 'average';
  }
  return 'label';
};

const resolveOrganName = (locale: OvipositionStatusLocale, organ: OrganData) =>
  locale.organNames[organ.id] || locale.organNames[organ.title] || organ.title;

const resolveEggType = (
  locale: OvipositionStatusLocale,
  typeName?: string | null,
) => {
  if (!typeName) {
    return locale.eggTypes.Hardshell || 'Hardshell';
  }
  return locale.eggTypes[typeName] || typeName;
};

const resolveTraitName = (
  locale: OvipositionStatusLocale,
  traitName?: string | null,
) => {
  if (!traitName) {
    return locale.labels.unknown;
  }
  return locale.traitNames[traitName] || traitName;
};

const normalizeHex = (value?: string | null): string => {
  if (!value) {
    return '#eee3c7';
  }
  const raw = value.startsWith('#') ? value : `#${value}`;
  return /^#[0-9a-fA-F]{6}$/.test(raw) ? raw : '#eee3c7';
};

export const OvipositionStatusView = (props: {
  locale: OvipositionStatusLocale;
}) => {
  const { locale } = props;
  const { act, data } = useBackend<StatusData>();
  const { organs = [], nutriment = 0 } = data;
  const [activeTab, setActiveTab] = useState<ActiveTab>('eggs');

  return (
    <Window title={locale.windowTitle} width={660} height={760}>
      <Window.Content scrollable>
        <Tabs textAlign="center">
          {(['eggs', 'settings', 'genetics'] as ActiveTab[]).map((tab) => (
            <Tabs.Tab
              key={tab}
              selected={activeTab === tab}
              onClick={() => setActiveTab(tab)}
            >
              {locale.tabs[tab]}
            </Tabs.Tab>
          ))}
        </Tabs>

        {organs.length === 0 ? (
          <Section>
            <Box textAlign="center" color="label" py={4}>
              <Icon name="egg" size={2} mb={2} />
              <br />
              {locale.emptyState}
            </Box>
          </Section>
        ) : (
          organs.map((organ) => (
            <OrganSection
              key={organ.id}
              act={act}
              activeTab={activeTab}
              organ={organ}
              nutriment={nutriment}
              locale={locale}
            />
          ))
        )}
      </Window.Content>
    </Window>
  );
};

const OrganSection = (props: {
  act: any;
  activeTab: ActiveTab;
  organ: OrganData;
  nutriment: number;
  locale: OvipositionStatusLocale;
}) => {
  const { act, activeTab, organ, nutriment, locale } = props;
  const organTitle = resolveOrganName(locale, organ);
  const allEggs = organ.eggs ?? [];
  const eggItems = allEggs.filter((egg) => !egg.is_hatchling);
  const hatchlingItems = allEggs.filter((egg) => egg.is_hatchling);
  const countLabel = organ.egg_capacity
    ? `${organ.egg_count}/${organ.egg_capacity}`
    : `${organ.egg_count}`;

  return (
    <Section
      title={
        <Box inline>
          <Icon name={organ.icon} mr={1} />
          {locale.labels.organ}
          {': '}
          {organTitle}
          {' ['}
          {countLabel}
          {']'}
        </Box>
      }
    >
      {activeTab === 'eggs' && (
        <>
          <OrganSummary organ={organ} nutriment={nutriment} locale={locale} />
          <EggActions act={act} organ={organ} locale={locale} />
          <EggList
            act={act}
            eggs={eggItems}
            title={locale.labels.eggsInside}
            locale={locale}
          />
          <EggList
            act={act}
            eggs={hatchlingItems}
            title={locale.labels.hatchlingsInside}
            locale={locale}
          />
        </>
      )}
      {activeTab === 'settings' && (
        <SettingsPanel act={act} organ={organ} locale={locale} />
      )}
      {activeTab === 'genetics' && (
        <GeneticsPanel act={act} organ={organ} locale={locale} />
      )}
    </Section>
  );
};

const OrganSummary = (props: {
  organ: OrganData;
  nutriment: number;
  locale: OvipositionStatusLocale;
}) => {
  const { organ, nutriment, locale } = props;
  const isOvi = organ.id === 'ovipositor';
  const isWomb = organ.id === 'womb';
  const cap = organ.egg_capacity || 0;
  const nxt = organ.next_egg_seconds ?? 0;

  return (
    <>
      {isOvi && (
        <Box mb={0.5}>
          {locale.labels.stored}
          {': '}
          <Box inline bold>
            {organ.egg_count} / {cap || 1}
          </Box>
          {' | '}
          {locale.labels.clutch}
          {': '}
          <Box inline bold>
            {organ.clutch_size || 1}
          </Box>
        </Box>
      )}
      {isWomb && (
        <Box mb={0.5}>
          {cap > 0 && (
            <>
              {locale.labels.limit}
              {': '}
              <Box inline bold>
                {organ.egg_count} / {cap}
              </Box>
              {' | '}
            </>
          )}
          {locale.labels.production}
          {': '}
          <Box inline bold color={organ.is_egg_layer ? 'good' : 'label'}>
            {organ.is_egg_layer ? locale.labels.active : locale.labels.inactive}
          </Box>
        </Box>
      )}
      <Box mb={0.5}>
        {locale.labels.nutrients}
        {': '}
        <Box inline bold>
          {nutriment} u
        </Box>
        {' | '}
        {locale.labels.interval}
        {': '}
        <Box inline bold>
          {organ.interval_seconds
            ? locale.formatTime(organ.interval_seconds)
            : organ.egg_stage !== undefined
              ? `${locale.labels.stage} ${organ.egg_stage}/2`
              : locale.labels.unknownStage}
        </Box>
      </Box>
      {nxt > 0 && (
        <Box mb={0.5}>
          {locale.labels.nextEgg}
          {': '}
          <Box inline bold>
            {locale.formatTime(nxt)}
          </Box>
        </Box>
      )}
      {(organ.hatchling_count ?? 0) > 0 && (
        <Box mb={0.5} bold color="bad">
          <Icon name="baby" mr={0.5} />
          {locale.labels.hatchlingsInside}
          {': '}
          {organ.hatchling_count}
        </Box>
      )}
    </>
  );
};

const EggActions = (props: {
  act: any;
  organ: OrganData;
  locale: OvipositionStatusLocale;
}) => {
  const { act, organ, locale } = props;
  return (
    <Stack mb={1} style={{ flexWrap: 'wrap' }}>
      {organ.id === 'ovipositor' && (
        <Stack.Item>
          <Button
            icon="egg"
            disabled={organ.egg_count <= 0}
            onClick={() => act('lay_ovipositor_eggs')}
          >
            {locale.labels.layEggs}
          </Button>
        </Stack.Item>
      )}
      {organ.settings?.can_configure && organ.eggs?.length > 0 && (
        <Stack.Item>
          <Button
            icon="hand"
            onClick={() =>
              act('extract_organ_eggs', { organ_id: organ.id })
            }
          >
            {locale.labels.extractAll}
          </Button>
        </Stack.Item>
      )}
    </Stack>
  );
};

const EggList = (props: {
  act: any;
  eggs: EggData[];
  title: string;
  locale: OvipositionStatusLocale;
}) => {
  const { act, eggs, title, locale } = props;
  if (!eggs.length) {
    return null;
  }
  return (
    <Box mt={1}>
      <Box bold color="label" mb={0.5}>
        {title}
        {':'}
      </Box>
      {eggs.map((egg, i) => (
        <EggDetail
          key={egg.ref || `${title}-${i}`}
          act={act}
          egg={egg}
          index={i + 1}
          locale={locale}
        />
      ))}
    </Box>
  );
};

const SettingsPanel = (props: {
  act: any;
  organ: OrganData;
  locale: OvipositionStatusLocale;
}) => {
  const { act, organ, locale } = props;
  const settings = organ.settings;
  if (!settings?.can_configure) {
    return <Box color="label">{locale.emptyState}</Box>;
  }

  return (
    <>
      <Preview settings={settings} locale={locale} />
      <SettingRow label={locale.labels.type}>
        {settings.available_egg_types.map((option) => (
          <Button
            key={option.id}
            selected={settings.egg_type === option.id}
            onClick={() =>
              act('set_organ_setting', {
                organ_id: organ.id,
                field: 'egg_type',
                value: option.id,
              })
            }
          >
            {resolveEggType(locale, option.name)}
          </Button>
        ))}
      </SettingRow>
      <SettingRow label={locale.labels.clutch}>
        <NumberInput
          minValue={1}
          maxValue={settings.max_clutch || 30}
          value={settings.clutch_size || 1}
          step={1}
          format={(value) => `${Math.round(value)}`}
          onChange={(value: number) =>
            act('set_organ_setting', {
              organ_id: organ.id,
              field: 'clutch_size',
              value,
            })
          }
        />
      </SettingRow>
      {organ.id === 'ovipositor' && (
        <SettingRow label={locale.labels.capacity}>
          <NumberInput
            minValue={1}
            maxValue={settings.max_capacity || 30}
            value={settings.capacity || 30}
            step={1}
            format={(value) => `${Math.round(value)}`}
            onChange={(value: number) =>
              act('set_organ_setting', {
                organ_id: organ.id,
                field: 'storage_capacity',
                value,
              })
            }
          />
        </SettingRow>
      )}
      <SettingRow label={locale.labels.scale}>
        <NumberInput
          minValue={50}
          maxValue={200}
          value={Math.round((settings.egg_scale || 1) * 100)}
          step={5}
          format={(value) => `${Math.round(value)}%`}
          onChange={(value: number) =>
            act('set_organ_setting', {
              organ_id: organ.id,
              field: 'egg_scale',
              value: value / 100,
            })
          }
        />
      </SettingRow>
      <TextSetting
        label={locale.labels.name}
        field="custom_name"
        organId={organ.id}
        value={settings.custom_name || ''}
        act={act}
        locale={locale}
      />
      <TextSetting
        label={locale.labels.description}
        field="custom_desc"
        organId={organ.id}
        multiline
        value={settings.custom_desc || ''}
        act={act}
        locale={locale}
      />
      <TextSetting
        label={locale.labels.organDescription}
        field="custom_organ_desc"
        organId={organ.id}
        multiline
        value={settings.custom_organ_desc || ''}
        act={act}
        locale={locale}
      />
      <ColorEditor act={act} organ={organ} settings={settings} locale={locale} />
      <SettingRow label={locale.labels.resourceDependent}>
        <Button.Checkbox
          checked={!!settings.resource_dependent}
          onClick={() =>
            act('set_organ_setting', {
              organ_id: organ.id,
              field: 'resource_dependent',
              value: settings.resource_dependent ? 0 : 1,
            })
          }
        >
          {settings.resource_dependent ? locale.labels.on : locale.labels.off}
        </Button.Checkbox>
        <Box inline color="label" ml={1}>
          {locale.labels.nutrientCost}
          {': '}
          {settings.nutrient_cost ?? 0} u
        </Box>
      </SettingRow>
      <SettingRow label={locale.labels.autoHatch}>
        {[
          ['profile', locale.labels.profileDefault],
          ['true', locale.labels.yes],
          ['false', locale.labels.no],
        ].map(([value, label]) => (
          <Button
            key={value}
            selected={
              value === 'profile'
                ? settings.auto_hatch === null ||
                  settings.auto_hatch === undefined
                : settings.auto_hatch === (value === 'true')
            }
            onClick={() =>
              act('set_organ_setting', {
                organ_id: organ.id,
                field: 'auto_hatch',
                value,
              })
            }
          >
            {label}
          </Button>
        ))}
      </SettingRow>
    </>
  );
};

const GeneticsPanel = (props: {
  act: any;
  organ: OrganData;
  locale: OvipositionStatusLocale;
}) => {
  const { act, organ, locale } = props;
  const settings = organ.settings;
  const activeTraits = settings?.egg_traits || [];

  return (
    <>
      {settings?.can_configure && (
        <SettingRow label={locale.labels.traits}>
          {settings.available_traits.map((trait) => (
            <Button.Checkbox
              key={trait.id}
              checked={activeTraits.includes(trait.id)}
              onClick={() =>
                act('toggle_organ_trait', {
                  organ_id: organ.id,
                  trait: trait.id,
                })
              }
            >
              {resolveTraitName(locale, trait.name)}
            </Button.Checkbox>
          ))}
        </SettingRow>
      )}
      {organ.eggs?.length > 0 && (
        <Box mt={1}>
          <Box bold color="label" mb={0.5}>
            {locale.labels.parents}
            {':'}
          </Box>
          {organ.eggs.map((egg, index) => (
            <Box key={egg.ref || index} ml={1} mb={0.5}>
              <Box bold>
                {index + 1}. {egg.name}
              </Box>
              <Box color="label">
                {locale.labels.mother}
                {': '}
                {egg.mother_name || locale.labels.unknown}
                {' | '}
                {locale.labels.father}
                {': '}
                {egg.father_name || locale.labels.unknown}
                {' | '}
                {egg.fertilized
                  ? locale.labels.fertilized
                  : locale.labels.unfertilized}
              </Box>
            </Box>
          ))}
        </Box>
      )}
    </>
  );
};

const SettingRow = (props: {
  label: string;
  children: ReactNode;
}) => {
  const { label, children } = props;
  return (
    <Box mb={1}>
      <Box bold color="label" mb={0.4}>
        {label}
      </Box>
      {children}
    </Box>
  );
};

const TextSetting = (props: {
  label: string;
  value: string;
  field: string;
  organId: string;
  multiline?: boolean;
  act: any;
  locale: OvipositionStatusLocale;
}) => {
  const { label, value, field, organId, multiline, act, locale } = props;
  const displayValue = value?.length ? value : locale.labels.profileDefault;

  return (
    <SettingRow label={label}>
      <Stack>
        <Stack.Item grow>
          <Box
            color={value?.length ? undefined : 'label'}
            style={{
              minHeight: multiline ? '48px' : '20px',
              whiteSpace: multiline ? 'pre-wrap' : 'nowrap',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
            }}
          >
            {displayValue}
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="pen"
            onClick={() =>
              act('edit_organ_text', {
                organ_id: organId,
                field,
              })
            }
          >
            {locale.labels.edit}
          </Button>
        </Stack.Item>
      </Stack>
    </SettingRow>
  );
};

const ColorEditor = (props: {
  act: any;
  organ: OrganData;
  settings: OrganSettings;
  locale: OvipositionStatusLocale;
}) => {
  const { act, organ, settings, locale } = props;
  const applyColor = (color: string) =>
    act('set_organ_setting', {
      organ_id: organ.id,
      field: 'custom_color',
      value: normalizeHex(color),
    });

  return (
    <SettingRow label={locale.labels.color}>
      <Stack align="center">
        <Stack.Item>
          <ColorSquares color={normalizeHex(settings.custom_color)} />
        </Stack.Item>
        <Stack.Item grow>
          <Box color="label">
            {settings.custom_color || locale.labels.defaultColor}
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="palette"
            onClick={() =>
              act('pick_organ_color', {
                organ_id: organ.id,
              })
            }
          >
            {locale.labels.pickColor}
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon="undo"
            onClick={() =>
              act('set_organ_setting', {
                organ_id: organ.id,
                field: 'custom_color',
                value: '',
              })
            }
          >
            {locale.labels.reset}
          </Button>
        </Stack.Item>
      </Stack>
      <Stack mt={0.75} style={{ flexWrap: 'wrap' }}>
        {settings.color_presets.map((preset) => (
          <Stack.Item key={preset.id}>
            <Button
              selected={
                normalizeHex(preset.color) === normalizeHex(settings.custom_color)
              }
              onClick={() => applyColor(preset.color)}
            >
              <Box
                inline
                mr={0.5}
                style={{
                  width: '10px',
                  height: '10px',
                  backgroundColor: preset.color,
                  border: '1px solid rgba(255,255,255,0.3)',
                }}
              />
              {preset.name}
            </Button>
          </Stack.Item>
        ))}
      </Stack>
    </SettingRow>
  );
};

const Preview = (props: {
  settings: OrganSettings;
  locale: OvipositionStatusLocale;
}) => {
  const { settings, locale } = props;
  const color = normalizeHex(settings.custom_color);
  const scale = settings.egg_scale || 1;
  return (
    <Box mb={1}>
      <Box bold color="label" mb={0.4}>
        {locale.labels.preview}
      </Box>
      <Stack align="center">
        <Stack.Item>
          <Box
            style={{
              width: `${28 * scale}px`,
              height: `${38 * scale}px`,
              backgroundColor: color,
              border: '2px solid rgba(255,255,255,0.25)',
              borderRadius: '50% 50% 45% 45%',
              boxShadow: 'inset -6px -8px 0 rgba(0,0,0,0.18)',
            }}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Box bold>{settings.custom_name || resolveEggType(locale, settings.egg_type_name)}</Box>
          <Box color="label">
            {resolveEggType(locale, settings.egg_type_name)}
            {' | '}
            {locale.labels.scale}
            {': '}
            {Math.round(scale * 100)}%
          </Box>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const EggDetail = (props: {
  act: any;
  egg: EggData;
  index: number;
  locale: OvipositionStatusLocale;
}) => {
  const { act, egg, index, locale } = props;
  const pct = egg.progress_pct;
  const sLabel = locale.formatStatus(egg.status, egg.time_left);
  const sColor = statusColor(egg.status);

  return (
    <Box
      mb={1}
      ml={1}
      style={{
        borderLeft: '2px solid rgba(255,255,255,0.15)',
        paddingLeft: '8px',
      }}
    >
      <Stack align="center">
        <Stack.Item grow>
          <Box bold>
            {index}. {egg.name} ({resolveEggType(locale, egg.type_name)})
          </Box>
        </Stack.Item>
        <Stack.Item>
          <ColorSquares color={egg.display_color} />
        </Stack.Item>
      </Stack>

      {egg.desc && (
        <Box color="label" fontSize="0.9em" style={{ whiteSpace: 'pre-wrap' }}>
          {egg.desc}
        </Box>
      )}

      <Stack>
        <Stack.Item grow>
          <Box color="label" fontSize="0.9em">
            {locale.labels.color}
            {': '}
            {egg.color_hex || locale.labels.defaultColor}
            {' | '}
            {locale.labels.scale}
            {': '}
            {Math.round((egg.scale || 1) * 100)}%
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Box fontSize="0.9em">
            {locale.labels.stage} {egg.stage}/{egg.max_stage}
          </Box>
        </Stack.Item>
      </Stack>

      <Stack align="center" mt={0.3}>
        <Stack.Item grow>
          <ProgressBar
            value={pct}
            maxValue={100}
            ranges={{
              bad: [0, 25],
              average: [25, 75],
              good: [75, 100],
            }}
          />
        </Stack.Item>
        <Stack.Item ml={1}>
          <Box bold color={sColor} fontSize="0.9em">
            {sLabel}
          </Box>
        </Stack.Item>
      </Stack>

      {!!egg.traits?.length && (
        <Box fontSize="0.85em" color="label" mt={0.3}>
          {locale.labels.traits}
          {': '}
          {egg.traits.map((trait) => resolveTraitName(locale, trait)).join(', ')}
        </Box>
      )}
      <Box fontSize="0.85em" color="label" mt={0.3}>
        {locale.labels.mother}
        {': '}
        {egg.mother_name || locale.labels.unknown}
        {' | '}
        {locale.labels.father}
        {': '}
        {egg.father_name || locale.labels.unknown}
      </Box>
      {egg.has_preg && (
        <Box fontSize="0.85em" color={egg.fertilized ? 'average' : 'label'} mt={0.3}>
          <Icon name="heart" mr={0.5} />
          {egg.fertilized ? locale.labels.fertilized : locale.labels.unfertilized}
          {egg.father_name ? ` ${locale.labels.by} ${egg.father_name}` : ''}
        </Box>
      )}
      {egg.hatch_inside && (
        <Box fontSize="0.85em" color="average" mt={0.2} italic>
          * {locale.labels.willHatchInside}
        </Box>
      )}
      {egg.has_preg && (egg.auto_hatch !== undefined || egg.hatch_inside) && (
        <Box fontSize="0.85em" color="label" mt={0.2}>
          {locale.labels.autoHatch}
          {': '}
          {egg.auto_hatch ? locale.labels.yes : locale.labels.no}
          {'. '}
          {locale.labels.internalBirth}
          {': '}
          {egg.hatch_inside ? locale.labels.yes : locale.labels.no}
          {'.'}
        </Box>
      )}
      <Stack mt={0.5}>
        <Stack.Item>
          <Button
            icon="hand"
            disabled={!egg.can_remove}
            onClick={() => act('extract_egg', { egg_ref: egg.ref })}
          >
            {locale.labels.extract}
          </Button>
        </Stack.Item>
        <Stack.Item>
          <Button.Checkbox
            checked={!!egg.auto_hatch}
            onClick={() => act('toggle_egg_auto_hatch', { egg_ref: egg.ref })}
          >
            {locale.labels.autoHatch}
          </Button.Checkbox>
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const ColorSquares = (props: { color: string | null }) => {
  const { color } = props;
  if (!color) {
    return null;
  }
  return (
    <Stack>
      {[1, 0.65, 0.35].map((opacity, i) => (
        <Stack.Item key={i} mr={i < 2 ? 0.2 : 0}>
          <Box
            inline
            style={{
              width: '10px',
              height: '10px',
              backgroundColor: color,
              opacity,
              border: '1px solid rgba(255,255,255,0.15)',
            }}
          />
        </Stack.Item>
      ))}
    </Stack>
  );
};
