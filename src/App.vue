<script setup>
import { ref, onMounted } from "vue";
import * as THREE from "three";
import { OrbitControls, GLTFLoader } from "three/examples/jsm/Addons.js";
import GUI from "lil-gui";

import vertexShader from "./glsl/vertexShader.glsl";
import fragmentShader from "./glsl/fragmentShader.glsl";

let scene, camera, renderer, controls, galaxy, gui;
const canvas = ref(null);

// todo 场景
scene = new THREE.Scene();
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

// ! 导入模型
// const gltfload = new GLTFLoader();
// gltfload.load("./model/bakedModel.glb", (model) => {
//   scene.add(model.scene);
// });

const plan = new THREE.Mesh(
  new THREE.PlaneGeometry(1, 1, 2, 2),
  new THREE.RawShaderMaterial({
    side: THREE.DoubleSide,
    vertexShader,
    fragmentShader,
    uniforms: {
      uTime: { value: 0 },
    },
    transparent: true,
    // wireframe: true,
  })
);

scene.add(plan);

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
