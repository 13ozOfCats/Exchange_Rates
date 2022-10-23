<script lang="js">
export default {
  props: {
    'rates': {
      type: Object,
      required: true
    },
  },
  data() {
    return {
      current: null,
    }
  },
  watch: {
    current: function (val) {
      this.$emit('newRate', val);
    }
  }
};
</script>

<template>
  <div class="rates-select">
    <div class="subtitle">
      Валюта:
    </div>
    <select name="ratesSelect" class="rates-select__select" v-model="current">
      <option v-for="(value, key) in rates" :key="key" :value="key">
        {{ value.Name }} ({{ key }})
      </option>
    </select>
  </div>
</template>

<style scoped lang="scss">
.rates-select {
  &__select {
    padding: 0 16px;
    width: 100%;
    margin-top: 8px;
    background: #ffffff;
    border: 1px solid #d8d8d8;
    font-style: normal;
    font-weight: bold;
    font-size: 16px;
    line-height: 24px;
    height: 40px;
    color: #000000;
    outline: none;
  }
}
</style>
