class FluidContainer extends React.Component {
  render() {
    return (
      <div className='fluid-container'>{this.props.children}</div>
      )
  }
}

class GridRow extends React.Component {
  render() {
    let className = ['row', this.props.className].join(' ');
    return (
      <div className={className}>{this.props.children}</div>
      )
  }
}