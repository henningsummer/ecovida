<template>
  <div >
    <transition-group name="fadeLeft" appear tag="div" class="opts">
      <div class="opt" v-for="(opt, index) in options" :key="opt" @click="setValue(opt)"
            :class="{ selected: opt.value === value, 'not-selected': value && opt.value !== value }"
            :style="{ 'animation-duration': `${2 - index / 5}s`, width: `${width}px`, height: `${height}px` }">
          <div>
            <h3>{{ opt.name }}</h3>
            <p v-if="opt.description">{{ opt.description }}</p>
          </div>
      </div>
    </transition-group>
  </div>
</template>

<script>
export default {
  props: {
    options: {
      required: true,
      type: Array
    },
    value: {
      type: String,
      default: ''
    },
    width: {
      type: Number,
      default: 300
    },
    height: {
      type: Number,
      default: 200
    }
  },
  methods: {
    setValue(opt) {
      this.value = opt.value;
      this.$emit('input', this.value)
    }
  }
}
</script>

<style>
  .opt {
    box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);
    transition: 0.3s;
    border: 1px solid rgb(94, 92, 92);
    margin-right: 20px;
    padding: 10px;
    border-radius: 5px;
    font-weight: 200;
    font-family: 'Montserrat', sans-serif;
    border-left: 7px solid rgb(105, 105, 105);
    display: flex;
    flex-direction: column;
  }

  .opt:hover {
    box-shadow: 0 16px 32px 0 rgba(0,0,0,0.2);
  }

  .opts {
    display: flex;
    flex-direction: row;
    justify-content: center;
  }

  .selected {
    background-color: lightgreen;
  }

  .not-selected {
    opacity: 0.3;
    box-shadow: 0 0px 0px 0 rgba(0,0,0,0.2);
  }
</style>
