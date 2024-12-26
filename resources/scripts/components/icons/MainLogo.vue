<template>
  <svg viewBox="0 0 425 65" xmlns="http://www.w3.org/2000/svg">
    <g id="svgGroup" stroke-linecap="round" fill-rule="evenodd" :stroke="style.stroke" :stroke-width="style.strokeWidth" :fill="style.fill" :style="style">
      <rect x="6.42" y="12.13" width="5.148" height="25.74" style="fill-rule:nonzero;"/>
      <path d="M22.512,23.866l13.032,14.544l1.368,0l-0,-26.244l-5.184,0l-0,14.544l-12.996,-15.12l-1.368,0l-0,26.28l5.148,0l-0,-14.004Z" style="fill-rule:nonzero;"/>
      <path d="M51.852,38.41l10.656,-26.28l-5.94,0l-3.456,8.748l-1.836,5.148l-1.872,-5.328l-3.42,-8.568l-5.94,0l10.656,26.28l1.152,0Z" style="fill-rule:nonzero;"/>
      <path d="M78.024,38.23c17.712,0 17.712,-26.532 -0,-26.532c-17.712,0 -17.712,26.532 -0,26.532Zm-0,-5.328c-10.296,0 -10.296,-15.912 -0,-15.912c10.296,0 10.296,15.912 -0,15.912Z" style="fill-rule:nonzero;"/>
      <rect x="96.132" y="12.13" width="5.148" height="25.74" style="fill-rule:nonzero;"/>
      <path d="M123.456,18.106l0.612,-5.292c-1.548,-0.684 -3.276,-1.008 -5.076,-1.008c-17.424,0 -17.46,26.136 -0,26.136c1.8,0 4.068,-0.432 5.652,-1.08l-0.684,-5.328c-0.972,0.504 -2.736,1.152 -4.968,1.152c-10.188,0 -10.188,-15.696 -0,-15.696c2.232,0 3.492,0.612 4.464,1.116Z" style="fill-rule:nonzero;"/>
      <path d="M142.068,37.87l-0,-5.148l-8.172,0l0,-5.148l6.768,0l-0,-5.148l-6.768,0l0,-5.148l7.74,0l0,-5.148l-12.888,0l-0,25.74l13.32,0Z" style="fill-rule:nonzero;"/>
      <path d="M147.972,32.326c-3.888,0 -3.888,5.796 -0,5.796c3.852,0 3.96,-5.796 -0,-5.796Z" style="fill-rule:nonzero;"/>
      <path d="M155.676,37.87l5.148,0l0,-10.08l6.84,10.08l6.372,0l-9.072,-13.032l8.352,-12.708l-6.012,0l-6.48,10.26l0,-10.26l-5.148,0l-0,25.74Z" style="fill-rule:nonzero;"/>
      <path d="M177.42,12.13l0,25.74l13.32,0l0,-5.148l-8.172,0l0,-20.592l-5.148,0Z" style="fill-rule:nonzero;"/>
      <rect x="195.168" y="12.13" width="5.148" height="25.74" style="fill-rule:nonzero;"/>
      <path d="M219.432,37.87l0,-5.148l-8.172,0l0,-5.148l6.768,0l0,-5.148l-6.768,0l0,-5.148l7.74,0l0,-5.148l-12.888,0l0,25.74l13.32,0Z" style="fill-rule:nonzero;"/>
      <path d="M224.256,12.13l0,25.74l13.32,0l0,-5.148l-8.172,0l0,-20.592l-5.148,0Z" style="fill-rule:nonzero;"/>
      <path d="M243.084,32.326c-3.888,0 -3.888,5.796 0,5.796c3.852,0 3.96,-5.796 0,-5.796Z" style="fill-rule:nonzero;"/>
      <path d="M255.936,23.866l13.032,14.544l1.368,0l0,-26.244l-5.184,0l0,14.544l-12.996,-15.12l-1.368,0l0,26.28l5.148,0l0,-14.004Z" style="fill-rule:nonzero;"/>
      <path d="M289.452,37.87l0,-5.148l-8.172,0l0,-5.148l6.768,0l0,-5.148l-6.768,0l0,-5.148l7.74,0l0,-5.148l-12.888,0l0,25.74l13.32,0Z" style="fill-rule:nonzero;"/>
      <path d="M303.672,37.87l0,-20.592l6.408,0l0,-5.112l-17.964,0l0,5.112l6.408,0l0,20.592l5.148,0Z" style="fill-rule:nonzero;"/>   </g>
  </svg>
</template>

<script setup>

import {ref} from 'vue'

const props = defineProps({
  darkColor: {
    type: String,
    default: 'rgba(var(--color-primary-500), var(--tw-text-opacity))',
  },
  lightColor: {
    type: String,
    default: 'rgba(var(--color-primary-400), var(--tw-text-opacity))',
  },
})

const style = ref({
  strokeWidth: '0.25mm',
  stroke: props.lightColor,
  fill: props.lightColor,
});

</script>
