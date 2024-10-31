<script setup>
import { ref, onMounted } from "vue";
import * as THREE from "three";
import { OrbitControls } from "three/examples/jsm/Addons.js";
import GUI from "lil-gui";

import vertexShader from "./glsl/vertexShader.glsl";
import fragmentShader from "./glsl/fragmentShader.glsl";

let scene, camera, renderer, controls, gui;
const canvas = ref(null);

// todo 场景
scene = new THREE.Scene();
scene.add(new THREE.AxesHelper(1));
gui = new GUI({});

// todo 相机
camera = new THREE.PerspectiveCamera(
  45,
  window.innerWidth / window.innerHeight,
  0.1,
  1000
);
camera.position.set(0, 1, 2);
camera.lookAt(0, 0, 0);

const plan = new THREE.Mesh(
  new THREE.PlaneGeometry(4, 4, 215, 215),
  new THREE.RawShaderMaterial({
    side: THREE.DoubleSide,
    vertexShader,
    fragmentShader,
    uniforms: {
      uTime: { value: 0 },
      uWaveSpeed: { value: 1 },
      uWaveAmplitude: { value: new THREE.Vector2(2, 1.5) },
      uWaveIntensity: { value: new THREE.Vector2(0.2, 0.2) },
      uDepthColor: { value: new THREE.Color("#186691") },
      uSurfaceColor: { value: new THREE.Color("#9bd8ff") },
    },
  })
);
plan.rotation.x = -Math.PI / 2;
scene.add(plan);

gui
  .add(plan.material.uniforms.uWaveSpeed, "value")
  .min(0)
  .max(5)
  .step(0.001)
  .name("波浪速度");

gui
  .add(plan.material.uniforms.uWaveAmplitude.value, "x")
  .min(0)
  .max(20)
  .step(0.01)
  .name("X轴波浪振幅");
gui
  .add(plan.material.uniforms.uWaveAmplitude.value, "y")
  .min(0)
  .max(20)
  .step(0.01)
  .name("Y轴波浪振幅");
gui
  .add(plan.material.uniforms.uWaveIntensity.value, "x")
  .min(0)
  .max(0.5)
  .step(0.001)
  .name("X轴波浪强度");
gui
  .add(plan.material.uniforms.uWaveIntensity.value, "y")
  .min(0)
  .max(0.5)
  .step(0.001)
  .name("Y轴波浪强度");
gui.addColor(plan.material.uniforms.uDepthColor, "value").name("波峰颜色");
gui.addColor(plan.material.uniforms.uSurfaceColor, "value").name("波谷颜色");

// ! 动画
const clock = new THREE.Clock();
const tick = () => {
  const elapsed = clock.getElapsedTime();
  requestAnimationFrame(tick);
  plan.material.uniforms.uTime.value = elapsed;

  renderer.render(scene, camera);
  controls.update();
};

onMounted(() => {
  // todo 渲染器
  controls = new OrbitControls(camera, canvas.value);
  renderer = new THREE.WebGLRenderer({
    canvas: canvas.value,
  });
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.render(scene, camera);

  // todo 执行动画
  tick();
});
</script>

<template>
  <canvas id="canvas" ref="canvas"></canvas>
</template>

<style scoped>
#canvas {
  position: absolute;
}
</style>
