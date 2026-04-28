const formatTime = (seconds: number): string => {
  if (seconds <= 0) {
    return '0 sec.';
  }
  const minutes = Math.floor(seconds / 60);
  const remainingSeconds = Math.round(seconds % 60);
  if (minutes > 0) {
    return `${minutes} min. ${remainingSeconds} sec.`;
  }
  return `${remainingSeconds} sec.`;
};

export default {
  windowTitle: 'My Wombs',
  emptyState: 'No reproductive organs detected.',
  tabs: {
    eggs: 'Eggs',
    settings: 'Settings',
    genetics: 'Genetics',
  },
  labels: {
    organ: 'ORGAN',
    eggsInside: 'EGGS INSIDE',
    stored: 'Stored',
    clutch: 'Clutch',
    capacity: 'Capacity',
    color: 'Color',
    type: 'Type',
    name: 'Name',
    description: 'Description',
    organDescription: 'Organ description',
    nutrients: 'Nutrients',
    nutrientCost: 'Cost',
    interval: 'Interval',
    resourceDependent: 'Resource Dep',
    limit: 'Limit',
    production: 'Production',
    nextEgg: 'Next egg',
    hatchlingsInside: 'Hatchlings inside',
    stage: 'Stage',
    scale: 'Size',
    traits: 'Traits',
    preview: 'Preview',
    parents: 'Parents',
    mother: 'Mother',
    father: 'Father',
    unknown: 'Unknown',
    defaultColor: 'Default',
    fertilized: 'Fertilized',
    unfertilized: 'Unfertilized',
    by: 'by',
    autoHatch: 'Auto Hatch',
    internalBirth: 'Internal Birth',
    willHatchInside: 'Will hatch inside carrier.',
    extract: 'Extract',
    extractAll: 'Extract eggs',
    layEggs: 'Lay eggs',
    edit: 'Edit',
    pickColor: 'Pick color',
    apply: 'Apply',
    reset: 'Reset',
    profileDefault: 'Profile',
    on: 'ON',
    off: 'OFF',
    active: 'Active',
    inactive: 'Inactive',
    yes: 'Yes',
    no: 'No',
    unknownStage: '-',
  },
  organNames: {
    ovipositor: 'OVIPOSITOR',
    womb: 'WOMB',
    anus: 'ANUS',
    guts: 'GUTS',
  },
  eggTypes: {
    Hardshell: 'Hardshell',
    Avian: 'Avian',
    Softshell: 'Softshell',
    Parasitic: 'Parasitic',
    Spider: 'Spider',
    'Bog Bug': 'Bog Bug',
    Harpy: 'Harpy',
    Embryo: 'Hatchling',
  },
  traitNames: {
    Aphrodisiac: 'Aphrodisiac',
    Poison: 'Poison',
    Parasite: 'Parasite',
    Accelerated: 'Accelerated',
    aphrodisiac: 'Aphrodisiac',
    poison: 'Poison',
    parasite: 'Parasite',
    fast_growth: 'Accelerated',
  },
  formatTime,
  formatStatus: (status: string, timeLeft: number): string => {
    if (status === 'ready') {
      return 'Ready.';
    }
    if (status === 'growing') {
      if (timeLeft > 0) {
        return `Ready in ${formatTime(timeLeft)}.`;
      }
      return 'Growing.';
    }
    return 'Dormant.';
  },
};
