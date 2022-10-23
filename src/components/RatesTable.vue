<script>
export default {
  name: "RatesTable",
  props: {
    date: {
      type: String,
      required: true
    },
    currencies: {
      type: Object,
      required: true
    }
  },
  methods: {
    getDifference(now, prev) {
      const difference = now - prev;
      return (difference > 0 ? "+" : "") + difference.toFixed(2);
    },
    getColor(now, prev) {
      const difference = (now - prev).toFixed(2);
      let color = "#000000";
      if (difference > 0) {
        color = "#00b956";
      } else if (difference < 0) {
        color = "#f62434";
      }
      return color;
    }
  }
};
</script>

<template>
  <div class="rates-table">
    <div class="title">Курс валют на {{ date }}</div>
    <table class="rates-table__course-table">
      <thead>
        <tr>
          <td>
            Код
          </td>
          <td>
            Единиц
          </td>
          <td>
            Курс
          </td>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(val, name) in currencies" :key="name">
          <td>
            {{ name }}
          </td>
          <td>
            {{ val.Nominal }}
          </td>
          <td
            :style="{
              color: getColor(val.Value, val.Previous)
            }"
          >
            {{ val.Value }} ({{ getDifference(val.Value, val.Previous) }})
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style scoped lang="scss">
.rates-table {
  &__course-table {
    margin-top: 16px;
    width: 100%;
    text-align: center;
  }
}
</style>
