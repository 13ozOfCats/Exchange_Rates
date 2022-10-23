<script lang="js">
import ExchangeRates from "./components/ExchangeRates";

export default {
  name: "App",
  components: {
    ExchangeRates
  }
};
</script>

<template>
  <div id="app">
    <ExchangeRates />
  </div>
</template>

<style lang="scss">
@import url("https://fonts.googleapis.com/css2?family=PT+Sans:wght@400;700&display=swap");

* {
  box-sizing: border-box;
}

body {
  font-family: PT Sans, sans-serif;
  font-style: normal;
}

.title {
  font-weight: bold;
  font-size: 16px;
  line-height: 24px;
  color: #000000;
}

.subtitle {
  font-size: 13px;
  line-height: 16px;
  color: rgba(51, 51, 51, 0.5);
}

.table {
  font-family: PT Sans, sans-serif;
  font-style: normal;
  font-weight: normal;
  font-size: 13px;
  line-height: 16px;
  margin-top: 16px;
  width: 100%;

  &__row {
    height: 32px;
    width: 100%;
  }

  &__val {
    text-align: right;
  }

  &__name {
    width: 20%;
  }

  &__num {
    width: 40%;
  }

  &__cost {
    width: 40%;
  }

  &__thead {
    color: rgba(51, 51, 51, 0.5);
    box-shadow: 0 1px 0 #d8d8d8;
  }

  &__tbody {
    text-transform: uppercase;
    color: #000000;
  }
}
</style>
