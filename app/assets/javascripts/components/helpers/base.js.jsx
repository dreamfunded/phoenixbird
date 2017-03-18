class Well extends React.Component {
  render() {
    return <div className='well'>{this.props.children}</div>
  }
}

class YearRangeSelect extends React.Component {
  render() {
    let date = new Date();
    let year = date.getFullYear();
    var start = year - 70
    let dateRange = Array.from(Array(90)).map((_x, i)=> { return start + i })
    let prompt = this.props.prompt;
    return (
      <SelectField prompt={prompt} options={dateRange} />
      )
  }
}

YearRangeSelect.defaultProps = {
  prompt: 'Year'
}